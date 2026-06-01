# Relatório - Operação Cofre Digital

## Respostas às Perguntas

---

### 1. Por que é importante nunca colocar secrets diretamente no código-fonte?

Usando a analogia do cofre: colocar um secret no código é como escrever a combinação
do cofre na porta de entrada do banco. Qualquer pessoa que tiver acesso ao repositório
(público ou não) consegue ler a senha.

Além disso, o código fica versionado no Git. Mesmo que a gente delete o secret depois,
ele continua no histórico de commits e qualquer um pode recuperar.

O certo é guardar os secrets no "cofre digital" (GitHub Secrets) e deixar o código
apenas ler as variáveis de ambiente, sem saber o valor real.

---

### 2. Como o "configure-once, deploy-many" melhora a segurança e eficiência?

A ideia é simples: a gente configura o secret UMA vez no GitHub Secrets e o mesmo
código funciona em vários ambientes (dev, staging, produção) sem precisar mudar nada.

Vantagens:
- Não precisamos criar imagens Docker diferentes para cada ambiente
- Se precisar trocar uma senha, basta atualizar no GitHub Secrets, sem mexer no código
- Reduz o risco de alguém "esquecer" o secret hardcoded em algum lugar

---

### 3. Por que máscaras de log são essenciais mesmo com sistemas de secrets seguros?

Os sistemas de secrets protegem na hora de configurar, mas durante a execução a
aplicação precisa usar o valor real do secret. Se o código logar esse valor
acidentalmente (ex: num erro, num debug), qualquer pessoa com acesso aos logs
consegue ver o secret.

A máscara garante que mesmo que o secret "vaze" para um log, ele aparece como
`ABCD****WXYZ` em vez do valor completo.

É uma camada a mais de segurança - como ter um cofre dentro de outro cofre.

---

## Estrutura do projeto

```
cofre-digital-deploy/
├── app/
│   ├── app.py           # Aplicação Flask
│   └── requirements.txt
├── docker/
│   └── Dockerfile       # Container seguro com usuário não-root
└── .github/
    └── workflows/
        └── deploy.yml   # Pipeline com secrets injetados pelo GitHub
```
