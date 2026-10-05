BEGIN;

INSERT INTO temas (nome, ordem) 
VALUES
('Fundamentos da Agilidade', 1), 
('Manifesto Ágil', 2),
('Introdução ao Scrum', 3), 
('Papéis do Scrum', 4),
('Eventos do Scrum', 5), 
('Artefatos do Scrum', 6),
('User Stories', 7), 
('Gestão do Product Backlog', 8),
('Kanban', 9), 
('Planejamento Ágil', 10),
('Métricas Ágeis', 11), 
('Qualidade em Projetos Ágeis', 12)
ON CONFLICT (nome) DO NOTHING;

COMMIT;