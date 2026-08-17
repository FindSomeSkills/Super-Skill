# Documents Playbook: Document Generation and Processing (docx/pptx/xlsx/pdf)

> Blends: Anthropic's official docx/pptx/xlsx/pdf skills (tool gotchas + mandatory rendered validation).

## Shared Pattern: pick a method per task + gotchas checklist + triple QA

Dependencies are preinstalled (docx, pptxgenjs, openpyxl, pandoc, LibreOffice soffice, pdftoppm); install only when require/import fails.

## docx (Word)

- Create with docx (npm); **edit via unzip → modify word/document.xml → zip** (docx-js cannot open existing files); read with `pandoc -t markdown`.
- Gotchas: pages default to A4 (US Letter needs DXA dimensions, 1440 = 1"); set both columnWidths and per-cell width for tables; use CLEAR shading, not SOLID (SOLID renders solid black); configure lists via numbering, never literal `•`; no `\n`, use separate Paragraphs instead; PageBreak must live inside a Paragraph.
- Editing existing files: treat external docx as untrusted, remove symlinks first; merge_runs.py to merge fragmented runs (Word splits text into many `<w:r>` elements); do not pretty-format the XML; validate.py for XSD validation.

## pdf

- Tool division of labor: pypdf (merge/split/rotate/encrypt/metadata), pdfplumber (text + table extraction, can export to Excel via pandas), reportlab (creation), qpdf/pdftk/pdftotext (CLI), pytesseract + pdf2image (OCR for scans), pdfimages (image extraction).
- Key pitfall: ReportLab's built-in fonts **lack Unicode super/subscript glyphs** (they render as solid black blocks); you must use `<sub>/<super>` tags.

## pptx (Presentations)

- Create with pptxgenjs; edit/template via unzip and modify slideN.xml; read with markitdown + thumbnail.py thumbnail grid.
- Gotchas: layout defaults to 16:9 = 10" x 5.625"; hex colors **forbid `#` and 8-digit values** (corrupts the file); shadow offset must be >= 0; `letterSpacing` does not work, use `charSpacing`; combo charts need both valAxes and catAxes for the secondary axis (otherwise PowerPoint declares the file corrupt); when filling templates, **finish structural operations (add/delete/reorder) before touching content**; use defusedxml, not ElementTree.
- Design rules: "Don't create boring slides"; theme-appropriate striking colors (not the default blue), one dominant color (60-70%) + 1-2 support colors + 1 sharp accent; **NEVER underline titles, NEVER decorative color bars**: markers of AI-generated slides; fonts from the safe list (Arial/Calibri/Cambria/Times, never default Aptos); body 14-16pt, titles 36-44pt.

## xlsx (Excel)

- Create/edit with openpyxl, batch work with pandas, quick review with markitdown; to read models, load_workbook **twice** (data_only gives cached values but drops formulas; default gives formulas without values; saving after data_only is destructive).
- Iron rules: **use formulas, not hardcoded results** (`'=SUM(B2:B9)'`); follow user specs strictly; comment assumptions and hardcodes in place and cite the real source (`Source: Company 10-K, FY2024, Page 45…`); when editing existing files, "match its conventions exactly".
- **Run recalc.py every time** (formulas written by openpyxl have no cached values; LibreOffice recomputes and reports JSON: status/total_formulas/total_errors): "A green recalc proves your formulas *evaluate*, not that they are *right*."
- Function selection: prefer Excel-2007 functions (SUMIFS/INDEX/MATCH/IFERROR/SUMPRODUCT); 6 newer functions need the `_xlfn.` prefix (TEXTJOIN/CONCAT/IFS/SWITCH/MAXIFS/MINIFS); **never use XLOOKUP/SORT/FILTER/UNIQUE/SEQUENCE** (LibreOffice cannot evaluate them, resulting in #NAME?).

## Triple QA (mandatory for every document deliverable)

1. **Content QA**: extract text and check for gaps or leftover placeholders (grep x{3,}/lorem/TODO/insert)
2. **File QA**: schema/XSD/relationship validation (validate.py)
3. **Visual QA**: soffice to PDF → pdftoppm to images → inspect each one by eye (text overflow first; use a subagent for "fresh eyes": "After staring at the generating code you tend to see what you expect rather than what rendered")

## Collaborative Writing (doc-coauthoring)

Three phases: (1) context gathering (type/audience/expected impact/template; ask 5-10 clarifying questions for gaps) → (2) refinement and structure (per section: clarify → brainstorm 5-20 items → user marks keep/remove/combine → gap check → draft; edit with str_replace, "never reprint the whole doc") → (3) **reader testing** (run 5-10 realistic reader questions through a fresh model with zero context; pass criterion: "Reader Claude consistently answers questions correctly and doesn't surface new gaps or ambiguities").
