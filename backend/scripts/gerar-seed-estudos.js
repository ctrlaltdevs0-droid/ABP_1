import { readFile, writeFile } from 'node:fs/promises';
import { fileURLToPath } from 'node:url';

export async function gerarSeed() {
  const temas = JSON.parse(await readFile(new URL('../database/content-estudos.json', import.meta.url), 'utf8'));
  if (temas.length !== 12 || new Set(temas.map(t => t.nome)).size !== 12) throw new Error('São necessários 12 temas únicos.');
  const sql = texto => "'" + texto.replaceAll("'", "''") + "'";
  const statements = ['-- Gerado por npm run seed:gerar; editar content-estudos.json.', 'BEGIN;'];
  temas.forEach((tema, index) => {
    if (!tema.texto || !/^https:\/\//.test(tema.recurso) || tema.questoes.length !== 4) throw new Error(`Tema incompleto: ${tema.nome}`);
    const temaId = `(SELECT idtemas FROM temas WHERE nome = ${sql(tema.nome)})`;
    statements.push(`INSERT INTO conteudos (temas_idtemas, titulo, descricao, recurso_url, codigo_seed, status)
VALUES (${temaId}, ${sql(tema.nome)}, ${sql(tema.texto)}, ${sql(tema.recurso)}, 'PB056-${index + 1}', TRUE)
ON CONFLICT (codigo_seed) DO NOTHING;`);
    tema.questoes.forEach((questao, i) => {
      if (questao.length !== 5 || new Set(questao.slice(1)).size !== 4 || questao[0].length > 400 || questao.slice(1).some(t => !t || t.length > 200)) throw new Error(`Questão inválida: ${tema.nome}/${i + 1}`);
      const codigo = `PB053-${index + 1}-${i + 1}`;
      // Um bloco insere questão e alternativas junto; a repetição preserva edições e revisão editorial.
      statements.push(`DO $seed$
DECLARE questao_id INTEGER;
BEGIN
  INSERT INTO questoes (temas_idtemas, enunciado, codigo_seed, status, status_editorial)
  VALUES (${temaId}, ${sql(questao[0])}, '${codigo}', FALSE, 'RASCUNHO')
  ON CONFLICT (codigo_seed) DO NOTHING RETURNING idquestoes INTO questao_id;
  IF questao_id IS NOT NULL THEN
    INSERT INTO alternativas (questoes_idquestoes, letra, texto, correta) VALUES
    ${Array.from({ length: 4 }, (_, j) => {
      const correta = (index + i) % 4;
      const pos = (j - correta + 4) % 4;
      return `(questao_id, '${'ABCD'[j]}', ${sql(questao[pos + 1])}, ${j === correta ? 'TRUE' : 'FALSE'})`;
    }).join(',\n    ')};
  END IF;
END $seed$;`);
    });
  });
  statements.push('COMMIT;');
  return statements.join('\n\n') + '\n';
}
if (process.argv[1] === fileURLToPath(import.meta.url)) {
  await writeFile(new URL('../database/seed-estudos.sql', import.meta.url), await gerarSeed());
}
