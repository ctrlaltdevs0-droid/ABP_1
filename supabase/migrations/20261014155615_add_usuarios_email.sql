-- Compatibilidade com bancos existentes: não inventa e-mails para usuários antigos.
-- Novos cadastros exigem e-mail na API; registros antigos podem continuar nulos.
ALTER TABLE public.usuarios ADD COLUMN IF NOT EXISTS email TEXT;
