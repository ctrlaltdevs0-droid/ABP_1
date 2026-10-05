BEGIN;

CREATE TABLE usuarios (
    idusuarios INTEGER GENERATED ALWAYS AS IDENTITY, 
    cpf CHAR(11) NOT NULL,
    nome VARCHAR(50) NOT NULL,
    senha_hash VARCHAR(100) NOT NULL,
    criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_usuarios
        PRIMARY KEY (idusuarios),

    CONSTRAINT uq_usuarios_cpf
        UNIQUE (cpf)
);

CREATE TABLE temas (
    idtemas INTEGER GENERATED ALWAYS AS IDENTITY,
    nome VARCHAR(100) NOT NULL,
    descricao VARCHAR(255),
    ordem INTEGER,
    ativo BOOLEAN DEFAULT TRUE,

    CONSTRAINT pk_temas
        PRIMARY KEY (idtemas),

    CONSTRAINT uq_temas_nome
        UNIQUE (nome)
);

CREATE TABLE conteudos (
    idconteudo INTEGER GENERATED ALWAYS AS IDENTITY,
    temas_idtemas INTEGER NOT NULL,
    titulo VARCHAR(50),
    descricao VARCHAR(400),
    status BOOLEAN DEFAULT TRUE,
    criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_conteudos
        PRIMARY KEY (idconteudo),

    CONSTRAINT fk_conteudos_temas
        FOREIGN KEY (temas_idtemas)
        REFERENCES temas(idtemas)
        ON DELETE CASCADE
);

CREATE TABLE questoes (
    idquestoes INTEGER GENERATED ALWAYS AS IDENTITY,
    temas_idtemas INTEGER NOT NULL,
    enunciado VARCHAR(400) NOT NULL,
    imagem_url VARCHAR(500),
    status BOOLEAN DEFAULT TRUE,

    CONSTRAINT pk_questoes
        PRIMARY KEY (idquestoes),

    CONSTRAINT fk_questoes_temas
        FOREIGN KEY (temas_idtemas)
        REFERENCES temas(idtemas)
        ON DELETE CASCADE
);

CREATE TABLE alternativas (
    idalternativas INTEGER GENERATED ALWAYS AS IDENTITY,
    questoes_idquestoes INTEGER NOT NULL,
    letra CHAR(1) NOT NULL,
    texto VARCHAR(200) NOT NULL,
    correta BOOLEAN DEFAULT FALSE,

    CONSTRAINT pk_alternativas
        PRIMARY KEY (idalternativas),

    CONSTRAINT fk_alternativas_questoes
        FOREIGN KEY (questoes_idquestoes)
        REFERENCES questoes(idquestoes)
        ON DELETE CASCADE,

    CONSTRAINT uq_alternativas_letra_questao
        UNIQUE (questoes_idquestoes, letra)
);

CREATE TABLE tentativas (
    idtentativas INTEGER GENERATED ALWAYS AS IDENTITY,
    usuarios_idusuarios INTEGER NOT NULL,
    iniciado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    expira_em TIMESTAMP,
    finalizado_em TIMESTAMP,
    status VARCHAR(20) DEFAULT 'EM_ANDAMENTO',
    acertos INTEGER DEFAULT 0,
    percentual DECIMAL(5,2) DEFAULT 0.00,
    aprovado BOOLEAN DEFAULT FALSE,

    CONSTRAINT pk_tentativas
        PRIMARY KEY (idtentativas),

    CONSTRAINT fk_tentativas_usuarios
        FOREIGN KEY (usuarios_idusuarios)
        REFERENCES usuarios(idusuarios)
        ON DELETE CASCADE,

    CONSTRAINT ck_tentativas_acertos
        CHECK (acertos >= 0),

    CONSTRAINT ck_tentativas_percentual
        CHECK (percentual >= 0 AND percentual <= 100)
);


CREATE TABLE tentativas_questoes (
    tentativas_idtentativas INTEGER NOT NULL,
    questoes_idquestoes INTEGER NOT NULL,

    CONSTRAINT pk_tentativas_questoes
        PRIMARY KEY (
            tentativas_idtentativas,
            questoes_idquestoes
        ),

    CONSTRAINT fk_tentativas_questoes_tentativa
        FOREIGN KEY (tentativas_idtentativas)
        REFERENCES tentativas(idtentativas)
        ON DELETE CASCADE,

    CONSTRAINT fk_tentativas_questoes_questao
        FOREIGN KEY (questoes_idquestoes)
        REFERENCES questoes(idquestoes)
        ON DELETE CASCADE
);

CREATE TABLE certificados (
    idcertificados INTEGER GENERATED ALWAYS AS IDENTITY,
    usuarios_idusuarios INTEGER NOT NULL,
    emitido_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    score INTEGER,
    percentual DECIMAL(5,2),
    ativo BOOLEAN DEFAULT TRUE,
    revogado_em TIMESTAMP,

    CONSTRAINT pk_certificados
        PRIMARY KEY (idcertificados),

    CONSTRAINT fk_certificados_usuarios
        FOREIGN KEY (usuarios_idusuarios)
        REFERENCES usuarios(idusuarios)
        ON DELETE CASCADE,

    CONSTRAINT ck_certificados_score
        CHECK (score >= 0),

    CONSTRAINT ck_certificados_percentual
        CHECK (percentual >= 0 AND percentual <= 100)
);

CREATE INDEX idx_conteudos_temas
    ON conteudos(temas_idtemas);

CREATE INDEX idx_questoes_temas
    ON questoes(temas_idtemas);

CREATE INDEX idx_alternativas_questoes
    ON alternativas(questoes_idquestoes);

CREATE INDEX idx_tentativas_usuarios
    ON tentativas(usuarios_idusuarios);

CREATE INDEX idx_tentativas_questoes_tentativa
    ON tentativas_questoes(tentativas_idtentativas);

CREATE INDEX idx_tentativas_questoes_questao
    ON tentativas_questoes(questoes_idquestoes);

CREATE INDEX idx_certificados_usuarios
    ON certificados(usuarios_idusuarios);
    

COMMIT;