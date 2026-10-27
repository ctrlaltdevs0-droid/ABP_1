-- Executar após a migração, seed.sql e seed-estudos.sql em banco de validação.
DO $validacao$
BEGIN
  IF (SELECT count(*) FROM temas WHERE ativo) <> 12 THEN
    RAISE EXCEPTION 'Esperados exatamente 12 temas ativos';
  END IF;
  IF (SELECT count(*) FROM conteudos WHERE codigo_seed LIKE 'PB056-%') <> 12 THEN
    RAISE EXCEPTION 'Esperados 12 materiais';
  END IF;
  IF (SELECT count(*) FROM questoes WHERE codigo_seed LIKE 'PB053-%') <> 48 THEN
    RAISE EXCEPTION 'Esperadas 48 questões';
  END IF;
  IF EXISTS (
    SELECT t.idtemas FROM temas t LEFT JOIN questoes q
      ON q.temas_idtemas = t.idtemas AND q.codigo_seed LIKE 'PB053-%'
    WHERE t.ativo GROUP BY t.idtemas HAVING count(q.idquestoes) <> 4
  ) THEN RAISE EXCEPTION 'Cada tema deve ter quatro questões da carga'; END IF;
  IF EXISTS (
    SELECT q.idquestoes FROM questoes q LEFT JOIN alternativas a ON a.questoes_idquestoes = q.idquestoes
    WHERE q.codigo_seed LIKE 'PB053-%' GROUP BY q.idquestoes
    HAVING count(a.idalternativas) <> 4 OR count(*) FILTER (WHERE a.correta) <> 1
  ) THEN RAISE EXCEPTION 'Cada questão deve ter quatro alternativas e uma correta'; END IF;
END $validacao$;
SELECT 'Carga validada: 12 temas, 12 materiais, 48 questões, 192 alternativas' AS resultado;
