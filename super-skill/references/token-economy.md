# Token Economy：输出精简经济学

> 融合：JuliusBrussee/caveman（实测 -65% token）、Waza anti-patterns、Karpathy（简洁）。

## 删什么
冠词（a/an/the，中文场景少）、填充词（just/really/basically/actually）、客套话（sure/certainly/happy to）、模糊语（hedging）、连接性废话（however/furthermore）、重复总结、复述结论。

## 绝不动什么
- 代码块与行内代码、URL/路径/命令、技术术语与专有名词、数字与单位、错误信息原文
- **否定词（not/never/no/only/except）——翻转语义比省任何 token 都贵**
- 因果/顺序信息：压缩导致歧义（"migrate table drop column backup first"）就切回白话

## 反直觉原则
- **不要发明缩写**（cfg/impl/req）——tokenizer 把缩写切得和全词一样多 token，零节省还费解；箭头 → 同理。
- 绝不为了"像精简"加词——压缩只能是减法；插入破碎语法反而更贵。
- "如果精简说法不比平实说法短，就用平实的。"

## 适用边界（何时必须放弃极简）
1. 安全警告 2. 不可逆操作确认 3. 多步序列（省略连词会误读）4. 压缩制造技术歧义 5. 用户困惑或重复提问。这五类立即切回完整白话，讲完再恢复。

## 持久化例外
代码注释、commit、文档、issue/PR 正文、记忆文件、第三方消息——**一律正常行文**（那是给别的读者看的）。"Compress the style, not the language." 保留用户语言。

## 行为层面
- 工具调用直接开火，无前奏、无"下一步我准备…"旁白。
- 结束即停：不追加总结、不宣布下一步、不加 "hope this helps"。
- 回复复杂度匹配问题复杂度。
- 不重复跑未变化的验证命令（第二次同命令不加信息）。

## 关键句
- "All technical substance stay. Only fluff die."
- "Never drop not/never/no/only/except — flip meaning worse than any token saved."
- "if caveman phrasing not shorter than plain phrasing, use plain."
