# Contrato de API - Parceiro Assistencial

Este documento define os modelos JSON esperados pelo aplicativo Móvel (Flutter) para integração com o Backend.

## 1. Autenticação e Login

### Check CPF
Verifica se o usuário existe e se é o primeiro acesso.
- **Endpoint**: `POST /check-cpf`
- **Request**:
```json
{
  "cpf": "12345678900"
}
```
- **Response (Sucesso)**:
```json
{
  "exists": true,
  "is_first_access": false,
  "name": "Carlos Alberto Valente"
}
```

## 2. Financeiro (Boletos)

### Listar Boletos
Retorna a lista de cobranças do beneficiário (Padrão Asaas).
- **Endpoint**: `GET /financial/boletos`
- **Response**:
```json
[
  {
    "id": "bol_123",
    "description": "Mensalidade - Fevereiro 2026",
    "value": 149.90,
    "due_date": "2026-02-10",
    "status": "pending", // paid, pending, expired
    "bar_code": "00190.12345...",
    "pix_copy_paste": "0002012658..."
  }
]
```

## 3. Rede Credenciada

### Listar Parceiros
Retorna os parceiros filtrados ou por geolocalização.
- **Endpoint**: `GET /partners`
- **Query Params**: `category` (optional), `search` (optional)
- **Response**:
```json
[
  {
    "id": "part_01",
    "name": "Hospital São José do Avaí",
    "category": "clinic", // clinic, laboratory, pharmacy
    "city": "Itaperuna",
    "address": "Rua Cel. Ramos, 159",
    "phone": "2238249200"
  }
]
```

## 4. Perfil e Dados

### Meus Dados
- **Endpoint**: `GET /profile`
- **Response**:
```json
{
  "name": "Carlos Alberto Valente",
  "cpf": "12345678900",
  "email": "carlos.valente@email.com",
  "phone": "22998876655",
  "plan_type": "DIAMANTE",
  "address": "Rua das Flores, 123 - Centro, Itaperuna/RJ"
}
```
