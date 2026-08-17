# Documents Playbook：文档生成与处理（docx/pptx/xlsx/pdf）

> 融合：Anthropic 官方 docx/pptx/xlsx/pdf 技能（工具 gotchas + 强制性渲染验证）。

## 共同范式：按任务选方法 + gotchas 清单 + 三重 QA

依赖预装（docx、pptxgenjs、openpyxl、pandoc、LibreOffice soffice、pdftoppm），require/import 失败才安装。

## docx（Word）

- 创建用 docx(npm)；**编辑走 unzip→改 word/document.xml→zip**（docx-js 打不开现有文件）；读取用 `pandoc -t markdown`。
- gotchas：页面默认 A4（美式 Letter 需 DXA 尺寸，1440=1″）；表格 columnWidths+每格 width 双设；shading 用 CLEAR 不用 SOLID（否则全黑）；列表用 numbering 配置、绝不写字面 `•`；`\n` 禁用改用独立 Paragraph；PageBreak 必须在 Paragraph 内。
- 编辑既有文件：外部 docx 不可信先删 symlink；merge_runs.py 合并碎片 run（Word 把文本切成众多 `<w:r>`）；改 XML 勿格式化美化；validate.py 做 XSD 校验。

## pdf

- 工具分工：pypdf（合并/拆分/旋转/加密/元数据）、pdfplumber（文本+表格提取，可配 pandas 导出 Excel）、reportlab（创建）、qpdf/pdftk/pdftotext（CLI）、pytesseract+pdf2image（扫描件 OCR）、pdfimages（抽图）。
- 关键坑：ReportLab 内置字体**无 Unicode 上下标字形**（渲染成实心黑块），必须用 `<sub>/<super>` 标签。

## pptx（演示文稿）

- 创建用 pptxgenjs；编辑/模板走 unzip 改 slideN.xml；读取用 markitdown + thumbnail.py 缩略图网格。
- gotchas：layout 默认 16:9=10″×5.625″；hex 颜色**禁 `#` 与 8 位**（损坏文件）；shadow offset 必须 ≥0；`letterSpacing` 无效用 `charSpacing`；组合图二级轴必须同时给 valAxes+catAxes（否则 PowerPoint 判文件损坏）；模板填充**先做完结构操作（增/删/排序）再改内容**；用 defusedxml 而非 ElementTree。
- 设计规范："Don't create boring slides"；主题相关醒目配色（勿默认蓝），一色主导（60-70%）+1-2 支撑色+1 锐利点缀；**NEVER 标题下划线、NEVER 装饰色条**——AI 生成幻灯片标志；字体走安全清单（Arial/Calibri/Cambria/Times，绝不默认 Aptos）；正文 14-16pt、标题 36-44pt。

## xlsx（Excel）

- 创建/编辑用 openpyxl，批量用 pandas，快速浏览 markitdown；读模型要 load_workbook **两次**（data_only 得缓存值丢公式；默认得公式无值；data_only 后保存是破坏性的）。
- 铁律：**用公式不用硬编码结果**（`'=SUM(B2:B9)'`）；严格按用户规格；假设与硬编码就地注释并引真实来源（`Source: Company 10-K, FY2024, Page 45…`）；编辑既有文件 "match its conventions exactly"。
- **每次必跑 recalc.py**（openpyxl 写出的公式无缓存值，LibreOffice 重算并报 JSON：status/total_formulas/total_errors）——"A green recalc proves your formulas *evaluate*, not that they are *right*."
- 函数选型：优先 Excel-2007 函数（SUMIFS/INDEX/MATCH/IFERROR/SUMPRODUCT）；6 个新函数需 `_xlfn.` 前缀（TEXTJOIN/CONCAT/IFS/SWITCH/MAXIFS/MINIFS）；**绝不用 XLOOKUP/SORT/FILTER/UNIQUE/SEQUENCE**（LibreOffice 无法求值→#NAME?）。

## 三重 QA（所有文档产物必做）

1. **内容 QA**：文本提取查缺漏/占位符残留（grep x{3,}/lorem/TODO/insert）
2. **文件 QA**：schema/XSD/关系校验（validate.py）
3. **视觉 QA**：soffice 转 PDF→pdftoppm 出图→逐张目检（文字溢出最优先；建议子代理 "fresh eyes"——"After staring at the generating code you tend to see what you expect rather than what rendered"）

## 协同写作（doc-coauthoring）

三阶段：① 语境收集（类型/受众/期望影响/模板，按缺口提 5-10 个澄清问题）→ ② 精修与结构（逐节：澄清→头脑风暴 5-20 项→用户圈定 keep/remove/combine→gap check→起草；编辑用 str_replace "never reprint the whole doc"）→ ③ **读者测试**（零上下文全新模型跑 5-10 个读者真实问题，通过标准="Reader Claude consistently answers questions correctly and doesn't surface new gaps or ambiguities"）。
