--Criando a Tabela de CLIENTE, que contera o seu respectvo CPF, NOME, EMAIL, EMPRESA, TELEFONE1 E TELEFONE2
--Realizamos diversos checks para verificar validade de email, telefone, e CPF
CREATE TABLE CLIENTE (
    CPF CHAR(14) NOT NULL,
    NOME VARCHAR2(40) NOT NULL,
    EMAIL VARCHAR2(60),
    EMPRESA VARCHAR2(40),
    TELEFONE1 NUMBER(20) NOT NULL,
    TELEFONE2 NUMBER(20),
    CONSTRAINT PK_CLIENTE PRIMARY KEY(CPF), --chave primaria da tabela
    CONSTRAINT CK1_CLIENTE CHECK(REGEXP_LIKE(CPF, '[0-9]{3}\.[0-9]{3}\.[0-9]{3}\-[0-9]{2}')), --para testar validade de cpf do cliente
    CONSTRAINT CK2_CLIENTE CHECK(EMAIL IS NULL OR EMAIL LIKE '_%@_%._%'), --para testar validade do email do cliente
    CONSTRAINT CK3_CLIENTE CHECK(TELEFONE1 >= 0), --para testar validade do telefone do cliente
    CONSTRAINT CK4_CLIENTE CHECK(TELEFONE2 IS NULL OR TELEFONE2 >= 0) --para testar validade do telefone do cliente
);

--Criando a Tabela dos ENDERECOS de um CLIENTE, que contera os enderecos de todos os clientes. Note que um cliente pode conter mais de um endereco.
--Realizamos checks para checar a validade do numero do endereco
CREATE TABLE ENDERECO_CLIENTE (
    CLIENTE_CPF CHAR(14) NOT NULL,
    ID_ENDERECO NUMBER(12) NOT NULL, --GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL, --AUTO_INCREMENT ("NAO PODE SER ESCRITO")
    NRO NUMBER(8),
    CIDADE VARCHAR2(60),
    COMPLEMENTO VARCHAR2(60), --INFORMACOES ADICIONAIS
    RUA VARCHAR2(80),
    BAIRRO VARCHAR2(60),
    CONSTRAINT PK_ENDERECO_CLIENTE PRIMARY KEY(CLIENTE_CPF, ID_ENDERECO), --chave primaria da tabela
    CONSTRAINT FK_ENDERECO_CLIENTE_CLIENTE FOREIGN KEY(CLIENTE_CPF) 
                REFERENCES CLIENTE(CPF) 
                ON DELETE CASCADE,
    CONSTRAINT CK1_ENDERECO_CLIENTE CHECK(NRO IS NULL OR NRO >= 0) --para testar validade do numero do endereco
);

--A linha abaixo se refere a uma maneira de fazer AUTO-INCREMENT em ORACLE, criando o que se denomina "sequencias"!
CREATE SEQUENCE SEQUENCE_ENDERECO_CLIENTE START WITH 1; --AUTO_INCREMENT em mySQL

--Criando TRIGGER de banco para endereco de cliente, importante para cuidar das insercoes de endereco!
CREATE OR REPLACE TRIGGER TRIGGER_SEQUENCE_END_CLIENTE 
    BEFORE INSERT ON ENDERECO_CLIENTE --antes de inserir, tome a seguinte regra
    FOR EACH ROW
    BEGIN
        SELECT SEQUENCE_ENDERECO_CLIENTE.NEXTVAL INTO :NEW.ID_ENDERECO FROM DUAL;
    END;
/

--Criando tabela de FESTA que armazenara todos os dados de uma festa.
--A coluna PRECO_TOTAL eh um atributo composto que eh calculado com TRIGGERS de banco, apos diversas insercoes, updates e deletes.
CREATE TABLE FESTA (
    NRO_REGISTRO NUMBER(12) NOT NULL, --GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL, --AUTO_INCREMENT ("NAO PODE SER ESCRITO"), <-- SOH FUNCIONA NA VERSAO 12, PARA VERSOES ANTERIORES -> TRATADO COM SEQUENCE E TRIGGERS ABAIXO
    NRO_CONVIDADOS NUMBER(12),
    ENDERECO VARCHAR2(240) NOT NULL,
    PRECO_FESTA NUMBER(12,2) DEFAULT 0 NOT NULL,
    TIPO CHAR(9) NOT NULL,
    DATA_HORA DATE NOT NULL,
    PRECO_TOTAL NUMBER(12,2) DEFAULT 0, --ATRIBUTO DERIVADO
    CLIENTE_CPF CHAR(14),
    CONSTRAINT PK_FESTA PRIMARY KEY(NRO_REGISTRO), --chave primaria da tabela
    CONSTRAINT FK_FESTA_CLIENTE FOREIGN KEY(CLIENTE_CPF)
            REFERENCES CLIENTE(CPF)
            ON DELETE SET NULL,
    CONSTRAINT CK1_FESTA CHECK(TIPO IN ('CASAMENTO', 'FORMATURA')), --Realizamos check para checar se o tipo eh valido, somente entre casamento e formatura
    CONSTRAINT CK2_FESTA CHECK(NRO_CONVIDADOS IS NULL OR NRO_CONVIDADOS >= 0), --Check para validar nro de convidados
    CONSTRAINT CK3_FESTA CHECK(PRECO_FESTA >= 0) --O preco da festa deve ser checado como positivo para fazer sentido semantico
);

--A linha abaixo se refere a uma maneira de fazer AUTO-INCREMENT em ORACLE, criando o que se denomina "sequencias"!
CREATE SEQUENCE SEQUENCE_FESTA START WITH 1; --AUTO_INCREMENT

--Criando TRIGGER de banco para validar inserts em festa, atualizando seu nro de registro automaticamente e checando preco total.
CREATE OR REPLACE TRIGGER TRIGGER_INITIALIZE_FESTA --AUTO_INCREMENT E ATUALIZAR PRECO TOTAL DA FESTA
    BEFORE INSERT ON FESTA
    FOR EACH ROW
    BEGIN
        IF INSERTING THEN --antes de inserir, tome a seguinte precaucao
            SELECT SEQUENCE_FESTA.NEXTVAL, :NEW.PRECO_FESTA 
                INTO :NEW.NRO_REGISTRO, :NEW.PRECO_TOTAL FROM DUAL;
        /*    
        ELSIF UPDATING THEN
            SELECT SEQUENCE_FESTA.NEXTVAL, (:OLD.PRECO_TOTAL - :OLD.PRECO_FESTA + :NEW.PRECO_FESTA) 
                INTO :NEW.NRO_REGISTRO, :NEW.PRECO_TOTAL FROM DUAL;
        */        
        END IF;
    END;
/

CREATE OR REPLACE TRIGGER TRIGGER_PRECO_TOTAL_FESTA --ATUALIZAR PRECO TOTAL DA FESTA
    BEFORE UPDATE ON FESTA
    FOR EACH ROW
    BEGIN --(uma vez que nao seja possivel atualizar a chave de festa: )
        --Se estamos atualizando a linha, entao teremos que subtrair o preco antigo e somar o preco novo da festa 
        --da linha atualizada para manter consistencia com o valor atualizado 
        SELECT (:NEW.PRECO_TOTAL - :OLD.PRECO_FESTA + :NEW.PRECO_FESTA) INTO :NEW.PRECO_TOTAL FROM DUAL;
    END;
/

CREATE OR REPLACE TRIGGER TRIGGER_INITIALIZE_FESTA_DATA --VERIFICAR DATA DA FESTA
    BEFORE INSERT OR UPDATE ON FESTA
    FOR EACH ROW
    BEGIN
        IF ((:NEW.DATA_HORA - SYSDATE) <= 7) THEN
            RAISE_APPLICATION_ERROR (-20006, 'Uma festa nao pode ser marcada com menos de 1 semana de antecedencia!');
        END IF;
    END;
/

--Criando tabela FUNCIONARIO, que armazenara tudo relativo a funcionarios de uma festa
--Tambem realizamos varios checks para verificar validade de atributos de diversas colunas
CREATE TABLE FUNCIONARIO (
    CPF CHAR(14) NOT NULL,
    NOME VARCHAR2(40) NOT NULL,
    EMAIL VARCHAR2(60),
    TELEFONE1 NUMBER(20) NOT NULL,
    TELEFONE2 NUMBER(20),
    FUNCAO CHAR(32) NOT NULL,
    FUNCIONARIO_GERENTE_CPF CHAR(14),
    CONSTRAINT PK_FUNCIONARIO PRIMARY KEY(CPF), --chave primaria da tabela
    CONSTRAINT FK_FUNCIONARIO_FUNCIONARIO FOREIGN KEY(FUNCIONARIO_GERENTE_CPF)
                REFERENCES FUNCIONARIO(CPF)
                ON DELETE SET NULL,
    CONSTRAINT CK1_FUNCIONARIO CHECK(REGEXP_LIKE(CPF, '[0-9]{3}\.[0-9]{3}\.[0-9]{3}\-[0-9]{2}')), --check para validar cpf
    CONSTRAINT CK2_FUNCIONARIO CHECK(EMAIL IS NULL OR EMAIL LIKE '_%@_%._%'), --check para validar email
    CONSTRAINT CK3_FUNCIONARIO CHECK(TELEFONE1 >= 0), --check para validar telefone
    CONSTRAINT CK4_FUNCIONARIO CHECK(TELEFONE2 IS NULL OR TELEFONE2 >= 0) --check para validar telefone
);

--Criando tabela da relacao entre FUNCIONARIO e FESTA, armazenando quais funcionarios estarao presentes em quais festas
CREATE TABLE FUNCIONARIO_FESTA (
    FUNCIONARIO_CPF CHAR(14) NOT NULL,
    FESTA_NRO_REGISTRO NUMBER(12) NOT NULL,
    PRECO_FUNCIONARIO NUMBER(12,2) DEFAULT 0 NOT NULL,
    CONSTRAINT PK_FUNCIONARIO_FESTA PRIMARY KEY(FUNCIONARIO_CPF, FESTA_NRO_REGISTRO), --chave primaria da tabela
    CONSTRAINT FK_FUNCIONARIO_FESTA_FUNC FOREIGN KEY(FUNCIONARIO_CPF)
                REFERENCES FUNCIONARIO(CPF)
                ON DELETE CASCADE,
    CONSTRAINT FK_FUNCIONARIO_FESTA_FESTA FOREIGN KEY(FESTA_NRO_REGISTRO)
                REFERENCES FESTA(NRO_REGISTRO)
                ON DELETE CASCADE,
    CONSTRAINT CK1_FUNCIONARIO_FESTA CHECK(PRECO_FUNCIONARIO >= 0) --checar a validade do preco do funcionario (tem que ser positivo)
);

--Criando TRIGGER de banco para a relacao entre FESTA e FUNCIONARIO, cuidando de inserts e updates dentro do banco de dados.
--Este trigger verificara se uma funcao de um funcionario pode ser atribuida ao tipo de festa especifica sendo realizada.
--Note que podem existir funcionarios em uma festa que nao farao parte da outra festa.
CREATE OR REPLACE TRIGGER TRIGGER_TIPO_FESTA_FUNCIONARIO --VERIFICAR SE PODE SER VINCULADO A ESTE TIPO DE FESTA (E SE NAO TEM UMA FESTA NO MESMO DIA)
    BEFORE INSERT ON FUNCIONARIO_FESTA
    FOR EACH ROW
    DECLARE
        TIPO_FESTA_AUX FESTA.TIPO%TYPE;
        FUNCAO_FUNCIONARIO_AUX FUNCIONARIO.FUNCAO%TYPE;
        DATA_FESTA_AUX FESTA.DATA_HORA%TYPE;
        NUMBER_AUX NUMBER(12);
    BEGIN
        SELECT TIPO, DATA_HORA INTO TIPO_FESTA_AUX, DATA_FESTA_AUX FROM FESTA
            WHERE :NEW.FESTA_NRO_REGISTRO = NRO_REGISTRO;
        SELECT FUNCAO INTO FUNCAO_FUNCIONARIO_AUX FROM FUNCIONARIO
            WHERE :NEW.FUNCIONARIO_CPF = CPF;
        
        --Rejeitando funcionarios ilegitimos ao tipo de festa apresentado
        IF (TIPO_FESTA_AUX = 'CASAMENTO' AND (FUNCAO_FUNCIONARIO_AUX IN ('COPEIRO')))
            OR (TIPO_FESTA_AUX = 'FORMATURA' AND (FUNCAO_FUNCIONARIO_AUX IN ('CONFEITEIRO', 'GARCOM'))) THEN
            RAISE_APPLICATION_ERROR (-20002, 'Um funcionario de festas do tipo ' || TIPO_FESTA_AUX ||
                                        ' nao pode conter esta funcao');

        END IF;
        
        SELECT COUNT(*) INTO NUMBER_AUX FROM FESTA F
            JOIN FUNCIONARIO_FESTA FF ON  F.NRO_REGISTRO = FF.FESTA_NRO_REGISTRO
            WHERE FF.FUNCIONARIO_CPF = :NEW.FUNCIONARIO_CPF 
            AND FF.FESTA_NRO_REGISTRO != :NEW.FESTA_NRO_REGISTRO
            AND TO_CHAR(DATA_FESTA_AUX, 'DD-MM-YYYY') = TO_CHAR(F.DATA_HORA, 'DD-MM-YYYY');
        
        IF NUMBER_AUX > 0 THEN
            RAISE_APPLICATION_ERROR (-20007, 'Este funcionario ja esta alocado para uma festa nesta data.');
        
        END IF;
    END;
/

--Criando TRIGGER de banco para atualizar automaticamente o PRECO TOTAL de uma festa, dado que este eh um atributo derivado
CREATE OR REPLACE TRIGGER TRIGGER_PRECO_TOTAL_FESTA_FUNC --ATUALIZAR PRECO TOTAL DA FESTA
    AFTER INSERT OR UPDATE OR DELETE ON FUNCIONARIO_FESTA
    FOR EACH ROW
    BEGIN
        --Se estamos deletando uma linha, entao teremos que subtrair o preco da linha deletada do preco total da festa
        IF DELETING THEN
            UPDATE FESTA SET PRECO_TOTAL = (PRECO_TOTAL - :OLD.PRECO_FUNCIONARIO)
                WHERE (:OLD.FESTA_NRO_REGISTRO = NRO_REGISTRO);
        
        --Se estamos inserindo uma linha, entao teremos que somar o preco da linha deletada do preco total da festa      
        ELSIF INSERTING THEN
            UPDATE FESTA SET PRECO_TOTAL = (PRECO_TOTAL + :NEW.PRECO_FUNCIONARIO)
                WHERE (:NEW.FESTA_NRO_REGISTRO = NRO_REGISTRO);
                
        --Se estamos atualizando a linha, entao teremos que subtrair o preco antigo e somar o preco novo da festa 
        --da linha atualizada para manter consistencia com o valor atualizado 
        ELSIF UPDATING THEN
            UPDATE FESTA SET PRECO_TOTAL = (PRECO_TOTAL - :OLD.PRECO_FUNCIONARIO)
                WHERE (:OLD.FESTA_NRO_REGISTRO = NRO_REGISTRO);
            UPDATE FESTA SET PRECO_TOTAL = (PRECO_TOTAL + :NEW.PRECO_FUNCIONARIO)
                WHERE (:NEW.FESTA_NRO_REGISTRO = NRO_REGISTRO);

        END IF;
    END;
/

--Criando tabela de UTENSILIO, que armazenara tudo relacionado aos utensilios das festas.
CREATE TABLE UTENSILIO (
    NOME VARCHAR2(40) NOT NULL,
    QTD_ESTOQUE NUMBER(12) DEFAULT 0 NOT NULL,
    TIPO CHAR(32) NOT NULL,
    CONSTRAINT PK_UTENSILIO PRIMARY KEY(NOME),
    CONSTRAINT CK1_UTENSILIO CHECK(QTD_ESTOQUE >= 0) --checando validade de quantidade de estoque, sendo que tem que obviamente ser positiva
);

--Criando tabela para a relacao entre UTENSILIO e FESTA, assim como validando quantidade de utensilio necessitada para uma festa
CREATE TABLE UTENSILIO_FESTA (
    FESTA_NRO_REGISTRO NUMBER(12) NOT NULL,
    UTENSILIO_NOME VARCHAR2(40) NOT NULL,
    QUANTIDADE NUMBER(12) DEFAULT 0 NOT NULL,
    CONSTRAINT PK_UTENSILIO_FESTA PRIMARY KEY(FESTA_NRO_REGISTRO, UTENSILIO_NOME), --chave primaria da tabela
    CONSTRAINT FK_UTENSILIO_FESTA_FESTA FOREIGN KEY(FESTA_NRO_REGISTRO)
                REFERENCES FESTA(NRO_REGISTRO)
                ON DELETE CASCADE,
    CONSTRAINT FK_UTENSILIO_FESTA_UTENSILIO FOREIGN KEY(UTENSILIO_NOME)
                REFERENCES UTENSILIO(NOME)
                ON DELETE CASCADE,
    CONSTRAINT CK1_UTENSILIO_FESTA CHECK(QUANTIDADE >= 0) --validando quantidade de utensilio necessitada, visto que deve ser um valor positivo
);

--Criando TRIGGER de banco para quantidade de estoque em utensilio_festa, atualizando ela conforme ela eh usada ou inserida
CREATE OR REPLACE TRIGGER TRIGGER_QTD_ESTOQUE_UTEN_FESTA --VERIFICAR SE TEM EM ESTOQUE ANTES DE RESERVAR UM UTENSILIO
    BEFORE INSERT ON UTENSILIO_FESTA
    FOR EACH ROW
    DECLARE
        QTD_ESTOQUE_AUX UTENSILIO.QTD_ESTOQUE%TYPE;
        QTD_EM_USO UTENSILIO.QTD_ESTOQUE%TYPE;
    BEGIN
        SELECT SUM(UF.QUANTIDADE) INTO QTD_EM_USO FROM UTENSILIO_FESTA UF
            JOIN FESTA F ON UF.FESTA_NRO_REGISTRO = F.NRO_REGISTRO
            WHERE (UF.UTENSILIO_NOME = :NEW.UTENSILIO_NOME)
                AND ((SYSDATE - F.DATA_HORA) <= 0); 
        SELECT QTD_ESTOQUE INTO QTD_ESTOQUE_AUX FROM UTENSILIO
            WHERE NOME = :NEW.UTENSILIO_NOME;
        
        IF QTD_EM_USO IS NULL THEN QTD_EM_USO := 0; END IF;

        IF QTD_ESTOQUE_AUX < (QTD_EM_USO + :NEW.QUANTIDADE) THEN
            RAISE_APPLICATION_ERROR (-20000, :NEW.UTENSILIO_NOME || ' nao tem esta quantidade disponivel em estoque! 
                                                Quantidade disponivel: ' || TO_CHAR(QTD_ESTOQUE_AUX - QTD_EM_USO));

        END IF;
    END;
/

--Criando tabela de DOCE no banco de dados, que armazenara todos os dados de doces das festas.
CREATE TABLE DOCE (
    NOME VARCHAR2(40) NOT NULL,
    MODELO VARCHAR2(40),
    PRECO_UNIDADE NUMBER(12,2) DEFAULT 0 NOT NULL,
    DESCRICAO CHAR(256),
    CONSTRAINT PK_DOCE PRIMARY KEY(NOME),
    CONSTRAINT CK1_DOCE CHECK(PRECO_UNIDADE >= 0) --checando validade de preco
);

-- Criando tabela da relacao entre DOCE e FESTA, relacionando cada doce usado por cada festa armazenada.
CREATE TABLE DOCE_FESTA (
    DOCE_NOME VARCHAR2(40) NOT NULL,
    FESTA_NRO_REGISTRO NUMBER(12) NOT NULL,
    QUANTIDADE NUMBER(12) DEFAULT 0 NOT NULL,
    CONSTRAINT PK_DOCE_FESTA PRIMARY KEY(DOCE_NOME, FESTA_NRO_REGISTRO), --chave primaria da tabela
    CONSTRAINT FK_DOCE_FESTA_DOCE FOREIGN KEY(DOCE_NOME)
                REFERENCES DOCE(NOME)
                ON DELETE CASCADE,
    CONSTRAINT FK_DOCE_FESTA_FESTA FOREIGN KEY(FESTA_NRO_REGISTRO)
                REFERENCES FESTA(NRO_REGISTRO)
                ON DELETE CASCADE,
    CONSTRAINT CK1_DOCE_FESTA CHECK(QUANTIDADE >= 0) --checando validade da quantidade de cada doce, tendo que ser um valor positivo
);

--Criando TRIGGER de banco para a relacao da tabela FESTA_DOCE, sendo que uma festa de formatura nao pode ter mesa de doces!
--SOMENTE FESTAS DE CASAMENTO PODERAO TER MESA DE DOCE!
CREATE OR REPLACE TRIGGER TRIGGER_TIPO_FESTA_DOCE --VERIFICAR SE PODE SER VINCULADO A ESTE TIPO DE FESTA
    BEFORE INSERT OR UPDATE ON DOCE_FESTA
    FOR EACH ROW
    DECLARE
        TIPO_FESTA_AUX FESTA.TIPO%TYPE;
    BEGIN
        SELECT TIPO INTO TIPO_FESTA_AUX FROM FESTA
            WHERE :NEW.FESTA_NRO_REGISTRO = NRO_REGISTRO;
    
        IF TIPO_FESTA_AUX = 'FORMATURA' THEN
            RAISE_APPLICATION_ERROR (-20003, 'Um doce nao pode ser vinculado a este tipo de festa');

        END IF;
    END;
/

--Criando TRIGGER de banco para atualizar o preco total da festa (ATUALIZAR O ATRIBUTO COMPOSTO PRECO_TOTAL da tabela FESTA)
--conforme a mesa de doces da festa de casamento vai aumentando, ou seja, conforme mais doces vao sendo inseridos na festa
CREATE OR REPLACE TRIGGER TRIGGER_PRECO_TOTAL_FESTA_DOCE --ATUALIZAR PRECO TOTAL DA FESTA
    AFTER INSERT OR UPDATE OR DELETE ON DOCE_FESTA
    FOR EACH ROW
    DECLARE
        PRECO_UNIDADE_AUX DOCE.PRECO_UNIDADE%TYPE;
    BEGIN
        --Se estamos deletando uma linha, entao teremos que subtrair o preco da linha deletada do preco total da festa
        IF DELETING THEN
            SELECT PRECO_UNIDADE INTO PRECO_UNIDADE_AUX FROM DOCE
                WHERE NOME = :OLD.DOCE_NOME;
            UPDATE FESTA SET PRECO_TOTAL = (PRECO_TOTAL - (PRECO_UNIDADE_AUX * :OLD.QUANTIDADE))
                WHERE (:OLD.FESTA_NRO_REGISTRO = NRO_REGISTRO);
        
        --Se estamos inserindo uma linha, entao teremos que somar o preco da linha deletada do preco total da festa  
        ELSIF INSERTING THEN
            SELECT PRECO_UNIDADE INTO PRECO_UNIDADE_AUX FROM DOCE
                WHERE NOME = :NEW.DOCE_NOME;
            UPDATE FESTA SET PRECO_TOTAL = (PRECO_TOTAL + (PRECO_UNIDADE_AUX * :NEW.QUANTIDADE))
                WHERE (:NEW.FESTA_NRO_REGISTRO = NRO_REGISTRO);
        
        --Se estamos atualizando a linha, entao teremos que subtrair o preco antigo e somar o preco novo da festa 
        --da linha atualizada para manter consistencia com o valor atualizado 
        ELSIF UPDATING THEN
            SELECT PRECO_UNIDADE INTO PRECO_UNIDADE_AUX FROM DOCE
                WHERE NOME = :OLD.DOCE_NOME;
            UPDATE FESTA SET PRECO_TOTAL = (PRECO_TOTAL - (PRECO_UNIDADE_AUX * :OLD.QUANTIDADE))
                WHERE (:OLD.FESTA_NRO_REGISTRO = NRO_REGISTRO);
            SELECT PRECO_UNIDADE INTO PRECO_UNIDADE_AUX FROM DOCE
                WHERE NOME = :NEW.DOCE_NOME;
            UPDATE FESTA SET PRECO_TOTAL = (PRECO_TOTAL + (PRECO_UNIDADE_AUX * :NEW.QUANTIDADE))
                WHERE (:NEW.FESTA_NRO_REGISTRO = NRO_REGISTRO);

        END IF;
    END;
/

--Criando tabela de BOLO, que armazenara todos os bolos que podem ser escolhidos nas festas.
CREATE TABLE BOLO (
    NOME VARCHAR2(40) NOT NULL,
    MODELO VARCHAR2(40),
    PRECO NUMBER(12,2) DEFAULT 0 NOT NULL,
    DESCRICAO VARCHAR2(256),
    CONSTRAINT PK_BOLO PRIMARY KEY(NOME),
    CONSTRAINT CK1_BOLO CHECK(PRECO >= 0) --checando validade do preco do bolo, que obviamente deve ser um valor positivo
);

--Criando tabela da relacao entre BOLO e FESTA, relacionando quais bolos foram pedidos em quais festas
CREATE TABLE BOLO_FESTA (
     BOLO_NOME VARCHAR2(40) NOT NULL,
     FESTA_NRO_REGISTRO NUMBER(12) NOT NULL,
     CONSTRAINT PK_BOLO_FESTA PRIMARY KEY(BOLO_NOME, FESTA_NRO_REGISTRO), --chave primaria da tabela
     CONSTRAINT FK_BOLO_FESTA_BOLO FOREIGN KEY(BOLO_NOME)
                 REFERENCES BOLO(NOME)
                 ON DELETE CASCADE,
     CONSTRAINT FK_BOLO_FESTA_FESTA FOREIGN KEY(FESTA_NRO_REGISTRO)
                 REFERENCES FESTA(NRO_REGISTRO)
                 ON DELETE CASCADE
);

--Criando TRIGGER de banco para a tabela da relacao FESTA_BOLO, que ira verificar se a festa eh do tipo CASAMENTO, uma vez que
--NAO PODE TER BOLO EM UMA FESTA DE FORMATURA!
CREATE OR REPLACE TRIGGER TRIGGER_TIPO_FESTA_BOLO --VERIFICAR SE PODE SER VINCULADO A ESTE TIPO DE FESTA
    BEFORE INSERT OR UPDATE ON BOLO_FESTA
    FOR EACH ROW
    DECLARE
        TIPO_FESTA_AUX FESTA.TIPO%TYPE;
    BEGIN
        SELECT TIPO INTO TIPO_FESTA_AUX FROM FESTA
            WHERE :NEW.FESTA_NRO_REGISTRO = NRO_REGISTRO;
    
        IF TIPO_FESTA_AUX = 'FORMATURA' THEN
            RAISE_APPLICATION_ERROR (-20004, 'Um bolo nao pode ser vinculado a este tipo de festa');

        END IF;
    END;
/

--Criando TRIGGER de banco para atualizar o preco total da festa conforme o valor do(s) bolo(s) escolhidos em uma festa especifica.
CREATE OR REPLACE TRIGGER TRIGGER_PRECO_TOTAL_FESTA_BOLO --ATUALIZAR PRECO TOTAL DA FESTA
    AFTER INSERT OR UPDATE OR DELETE ON BOLO_FESTA
    FOR EACH ROW
    DECLARE
        PRECO_AUX BOLO.PRECO%TYPE;
    BEGIN
        --Se estamos deletando uma linha, entao teremos que subtrair o preco da linha deletada do preco total da festa
        IF DELETING THEN
            SELECT PRECO INTO PRECO_AUX FROM BOLO
                WHERE NOME = :OLD.BOLO_NOME;
            UPDATE FESTA SET PRECO_TOTAL = (PRECO_TOTAL - PRECO_AUX)
                WHERE (:OLD.FESTA_NRO_REGISTRO = NRO_REGISTRO);
        
        --Se estamos inserindo uma linha, entao teremos que somar o preco da linha deletada do preco total da festa 
        ELSIF INSERTING THEN
            SELECT PRECO INTO PRECO_AUX FROM BOLO
                WHERE NOME = :NEW.BOLO_NOME;
            UPDATE FESTA SET PRECO_TOTAL = (PRECO_TOTAL + PRECO_AUX)
                WHERE (:NEW.FESTA_NRO_REGISTRO = NRO_REGISTRO);
        
        --Se estamos atualizando a linha, entao teremos que subtrair o preco antigo e somar o preco novo da festa 
        --da linha atualizada para manter consistencia com o valor atualizado  
        ELSIF UPDATING THEN
            SELECT PRECO INTO PRECO_AUX FROM BOLO
                WHERE NOME = :OLD.BOLO_NOME;
            UPDATE FESTA SET PRECO_TOTAL = (PRECO_TOTAL - PRECO_AUX)
                WHERE (:OLD.FESTA_NRO_REGISTRO = NRO_REGISTRO);
            SELECT PRECO INTO PRECO_AUX FROM BOLO
                WHERE NOME = :NEW.BOLO_NOME;
            UPDATE FESTA SET PRECO_TOTAL = (PRECO_TOTAL + PRECO_AUX)
                WHERE (:NEW.FESTA_NRO_REGISTRO = NRO_REGISTRO);

        END IF;
    END;
/

--Criando a tabela de ALIMENTO, que armazenara todos os alimentos que poderao ser pedidos em todas as festas armazenadas.
CREATE TABLE ALIMENTO (
    NOME VARCHAR2(40) NOT NULL,
    PRECO_PESSOA NUMBER(12,2) DEFAULT 0 NOT NULL,
    DESCRICAO VARCHAR2(256),
    TIPO_ALIMENTO CHAR(6) NOT NULL,
    PRONTO NUMBER(1) DEFAULT 0 NOT NULL,
    TIPO_COMIDA_BEBIDA CHAR(15) NOT NULL,
    CONSTRAINT PK_ALIMENTO PRIMARY KEY(NOME), --chave primaria da tabela
    CONSTRAINT CK_ALIMENTO_TIPO_ALIMENTO CHECK((TIPO_ALIMENTO IN ('COMIDA') --checanco validade de tipo de alimento
                AND TIPO_COMIDA_BEBIDA IN ('ENTRADA', 'GUARNICAO', 'SALGADO', 'APERITIVO', 'MOLHO', 'SOBREMESA', 'PRATO PRINCIPAL'))
                OR (TIPO_ALIMENTO IN ('BEBIDA')
                AND TIPO_COMIDA_BEBIDA IN ('NAO ALCOOLICA', 'ALCOOLICA'))),
    CONSTRAINT CK1_ALIMENTO CHECK(PRECO_PESSOA >= 0), --checando validade de preco por pessoa, que deve ser um valor positivo
    CONSTRAINT CK2_ALIMENTO CHECK(PRONTO IN (0, 1)) --checando validade no boolean entre PRONTO - 1 e NAO PRONTO - 0
);

--Criando tabela da relacao entre ALIMENTO e FESTA, referenciando quais alimentos estarao presentes em uma festa especifica e
--validando a quantidade de alimento que sera necessaria para essa festa
CREATE TABLE ALIMENTO_FESTA (
    ALIMENTO_NOME VARCHAR2(40) NOT NULL,
    FESTA_NRO_REGISTRO NUMBER(12) NOT NULL,
    QUANTIDADE NUMBER(12) DEFAULT 0 NOT NULL,
    CONSTRAINT PK_ALIMENTO_FESTA PRIMARY KEY(ALIMENTO_NOME, FESTA_NRO_REGISTRO), --chave primaria da tabela
    CONSTRAINT FK_ALIMENTO_FESTA_ALIMENTO FOREIGN KEY(ALIMENTO_NOME)
                REFERENCES ALIMENTO(NOME)
                ON DELETE CASCADE,
    CONSTRAINT FK_ALIMENTO_FESTA_FESTA FOREIGN KEY(FESTA_NRO_REGISTRO)
                REFERENCES FESTA(NRO_REGISTRO)
                ON DELETE CASCADE,
    CONSTRAINT CK1_ALIMENTO_FESTA CHECK(QUANTIDADE >= 0) --checando validade de quantidade de alimento necessaria, que deve ser um valor positivo
);

--Criando TRIGGER de banco para a relacao entre FESTA e ALIMENTO, validando os tipos de alimento que poderao estar presentes em 
--uma determinada festa!
CREATE OR REPLACE TRIGGER TRIGGER_TIPO_FESTA_ALIMENTO --VERIFICAR SE PODE SER VINCULADO A ESTE TIPO DE FESTA
    BEFORE INSERT OR UPDATE ON ALIMENTO_FESTA
    FOR EACH ROW
    DECLARE
        TIPO_FESTA_AUX FESTA.TIPO%TYPE;
        TIPO_COM_BEB_ALIMENTO_AUX ALIMENTO.TIPO_COMIDA_BEBIDA%TYPE;
    BEGIN
        SELECT TIPO INTO TIPO_FESTA_AUX FROM FESTA
            WHERE :NEW.FESTA_NRO_REGISTRO = NRO_REGISTRO;
        SELECT TIPO_COMIDA_BEBIDA INTO TIPO_COM_BEB_ALIMENTO_AUX FROM ALIMENTO
            WHERE :NEW.ALIMENTO_NOME = NOME;
    
        IF (TIPO_FESTA_AUX = 'CASAMENTO' AND (TIPO_COM_BEB_ALIMENTO_AUX IN ('SALGADO')))
            OR (TIPO_FESTA_AUX = 'FORMATURA' AND (TIPO_COM_BEB_ALIMENTO_AUX IN ('ENTRADA'))) THEN
            RAISE_APPLICATION_ERROR (-20005, 'Um alimento de festas do tipo ' || TIPO_FESTA_AUX ||
                                        ' nao pode conter este tipo');

        END IF;
    END;
/

--Criando TRIGGER de banco para a relacao entre FESTA e ALIMENTO, que atualizara automaticamente o preco total da festa
-- (atributo derivado de FESTA) conforme os precos por pessoa dos alimentos escolhidos pelo cliente da festa
CREATE OR REPLACE TRIGGER TRIGGER_PRECO_TOTAL_FESTA_ALIM --ATUALIZAR PRECO TOTAL DA FESTA
    AFTER INSERT OR UPDATE OR DELETE ON ALIMENTO_FESTA
    FOR EACH ROW
    DECLARE
        PRECO_PESSOA_AUX ALIMENTO.PRECO_PESSOA%TYPE;
    BEGIN
        --Se estamos deletando uma linha, entao teremos que subtrair o preco da linha deletada do preco total da festa
        IF DELETING THEN
            SELECT PRECO_PESSOA INTO PRECO_PESSOA_AUX FROM ALIMENTO
                WHERE NOME = :OLD.ALIMENTO_NOME;
            UPDATE FESTA SET PRECO_TOTAL = (PRECO_TOTAL - (PRECO_PESSOA_AUX * :OLD.QUANTIDADE))
                WHERE (:OLD.FESTA_NRO_REGISTRO = NRO_REGISTRO);
        
        --Se estamos inserindo uma linha, entao teremos que somar o preco da linha deletada do preco total da festa
        ELSIF INSERTING THEN
            SELECT PRECO_PESSOA INTO PRECO_PESSOA_AUX FROM ALIMENTO
                WHERE NOME = :NEW.ALIMENTO_NOME;
            UPDATE FESTA SET PRECO_TOTAL = (PRECO_TOTAL + (PRECO_PESSOA_AUX * :NEW.QUANTIDADE))
                WHERE (:NEW.FESTA_NRO_REGISTRO = NRO_REGISTRO);
        
        --Se estamos atualizando a linha, entao teremos que subtrair o preco antigo e somar o preco novo da festa 
        --da linha atualizada para manter consistencia com o valor atualizado    
        ELSIF UPDATING THEN
            SELECT PRECO_PESSOA INTO PRECO_PESSOA_AUX FROM ALIMENTO
                WHERE NOME = :OLD.ALIMENTO_NOME;
            UPDATE FESTA SET PRECO_TOTAL = (PRECO_TOTAL - (PRECO_PESSOA_AUX * :OLD.QUANTIDADE))
                WHERE (:OLD.FESTA_NRO_REGISTRO = NRO_REGISTRO);
            SELECT PRECO_PESSOA INTO PRECO_PESSOA_AUX FROM ALIMENTO
                WHERE NOME = :NEW.ALIMENTO_NOME;
            UPDATE FESTA SET PRECO_TOTAL = (PRECO_TOTAL + (PRECO_PESSOA_AUX * :NEW.QUANTIDADE))
                WHERE (:NEW.FESTA_NRO_REGISTRO = NRO_REGISTRO);

        END IF;
    END;
/

--Criando tabela de PRODUTO, que indicara o produto necessitado para preparo de um determinado alimento
CREATE TABLE PRODUTO (
    NOME VARCHAR2(40) NOT NULL,
    DESCRICAO VARCHAR2(256),
    CONSTRAINT PK_PRODUTO PRIMARY KEY(NOME)
);

--Criando tabela da relacao entre PRODUTO e ALIMENTO, que indicara quais serao os produtos necessarios para se fazer determinado
--alimento da tabela de alimentos.
CREATE TABLE PRODUTO_ALIMENTO (
    PRODUTO_NOME VARCHAR2(40) NOT NULL,
    ALIMENTO_NOME VARCHAR2(40) NOT NULL,
    TIPO_QUANTIDADE CHAR(12) NOT NULL,
    QUANTIDADE NUMBER(12) DEFAULT 0 NOT NULL,
    CONSTRAINT PK_PRODUTO_ALIMENTO PRIMARY KEY(PRODUTO_NOME, ALIMENTO_NOME), --chave primaria da tabela
    CONSTRAINT FK_PRODUTO_ALIMENTO_PRODUTO FOREIGN KEY(PRODUTO_NOME)
                REFERENCES PRODUTO(NOME)
                ON DELETE CASCADE,
    CONSTRAINT FK_PRODUTO_ALIMENTO_ALIMENTO FOREIGN KEY(ALIMENTO_NOME)
                REFERENCES ALIMENTO(NOME)
                ON DELETE CASCADE,
    CONSTRAINT CK1_PRODUTO_ALIMENTO CHECK(QUANTIDADE >= 0) --checando validade de quantidade, pois deve ser um valor positivo
);

--Criando tabela da relacao entre PRODUTO e BOLO, indicando quais produtos serao necessarios para se fazer determinado bolo
CREATE TABLE PRODUTO_BOLO (
    PRODUTO_NOME VARCHAR2(40) NOT NULL,
    BOLO_NOME VARCHAR2(40) NOT NULL,
    TIPO_QUANTIDADE CHAR(12) NOT NULL,
    QUANTIDADE NUMBER(12) DEFAULT 0 NOT NULL,
    CONSTRAINT PK_PRODUTO_BOLO PRIMARY KEY(PRODUTO_NOME, BOLO_NOME), --chave primaria da tabela
    CONSTRAINT FK_PRODUTO_BOLO_PRODUTO FOREIGN KEY(PRODUTO_NOME)
                REFERENCES PRODUTO(NOME)
                ON DELETE CASCADE,  
    CONSTRAINT FK_PRODUTO_BOLO_BOLO FOREIGN KEY(BOLO_NOME)
                REFERENCES BOLO(NOME)
                ON DELETE CASCADE,
    CONSTRAINT CK1_PRODUTO_BOLO CHECK(QUANTIDADE >= 0) --checando validade de quantidade, pois deve ser um valor positivo
);

--Criando tabela da relacao entre PRODUTO e DOCE, indicando quais produtos serao necessarios para se fazer determinado doce
CREATE TABLE PRODUTO_DOCE (
    PRODUTO_NOME VARCHAR2(40) NOT NULL,
    DOCE_NOME VARCHAR2(40) NOT NULL,
    TIPO_QUANTIDADE CHAR(12) NOT NULL,
    QUANTIDADE NUMBER(12) DEFAULT 0 NOT NULL,
    CONSTRAINT PK_PRODUTO_DOCE PRIMARY KEY(PRODUTO_NOME, DOCE_NOME), --chave primaria da tabela
    CONSTRAINT FK_PRODUTO_DOCE_PRODUTO FOREIGN KEY(PRODUTO_NOME)
                REFERENCES PRODUTO(NOME)
                ON DELETE CASCADE,
    CONSTRAINT FK_PRODUTO_DOCE_DOCE FOREIGN KEY(DOCE_NOME)
                REFERENCES DOCE(NOME)
                ON DELETE CASCADE,
    CONSTRAINT CK1_PRODUTO_DOCE CHECK(QUANTIDADE >= 0) --checando validade de quantidade, pois deve ser um valor positivo
);

--Criando tabela de FORNECEDOR_ALIMENTOS, que indicara todos os fornecedores de alimentos que terao de ser contatados para
--fornecer os alimentos ou produtos necessarios para confeccao na hora da festa dos alimentos.
CREATE TABLE FORNECEDOR_ALIMENTOS (
    CNPJ CHAR(18) NOT NULL,
    NOME VARCHAR2(40) NOT NULL,
    EMAIL VARCHAR2(60),
    ENDERECO VARCHAR2(240),
    TELEFONE1 NUMBER(20) NOT NULL,
    TELEFONE2 NUMBER(20),
    CONSTRAINT PK_FORNECEDOR_ALIMENTOS PRIMARY KEY(CNPJ), --chave primaria da tabela
    CONSTRAINT CK1_FORNECEDOR_ALIMENTOS CHECK(REGEXP_LIKE(CNPJ, '[0-9]{2}\.[0-9]{3}\.[0-9]{3}\/[0-9]{4}\-[0-9]{2}')), --checando validade de CPF
    CONSTRAINT CK2_FORNECEDOR_ALIMENTOS CHECK(EMAIL IS NULL OR EMAIL LIKE '_%@_%._%'), --checando validade de email
    CONSTRAINT CK3_FORNECEDOR_ALIMENTOS CHECK(TELEFONE1 >= 0), --checando validade de telefone
    CONSTRAINT CK4_FORNECEDOR_ALIMENTOS CHECK(TELEFONE2 IS NULL OR TELEFONE2 >= 0) --checando validade de telefone
);

--Criando tabela de NOTA_FISCAL de uma determinada encomenda
CREATE TABLE NOTA_FISCAL (
    NRO_FISCAL VARCHAR2(44) NOT NULL,
    DATA_EMISSAO DATE DEFAULT SYSDATE NOT NULL,
    PRECO_TOTAL NUMBER(10,2) DEFAULT 0 NOT NULL, --ATRIBUTO DERIVADO
    CONSTRAINT PK_NOTA_FISCAL PRIMARY KEY(NRO_FISCAL) --chave primaria da tabela
);

--Criando TRIGGER de banco para inicializar a nota fiscal com valor zero, antes de inserir uma nova nota fiscal na tabela
CREATE OR REPLACE TRIGGER TRIGGER_INITIALIZE_NOTA_FISCAL --ATUALIZAR PRECO TOTAL DA NOTA_FISCAL
    BEFORE INSERT ON NOTA_FISCAL
    FOR EACH ROW
    BEGIN
        IF INSERTING THEN
            SELECT 0 
                INTO :NEW.PRECO_TOTAL FROM DUAL;
        /*    
        ELSIF UPDATING THEN
            SELECT :OLD.PRECO_TOTAL 
                INTO :NEW.PRECO_TOTAL FROM DUAL;
        */        
        END IF;
    END;
/

--Criando tabela de ENCOMENDA, que armazenara todas as encomendas necessarias para a confeccao de todos os alimentos com seus 
--respectivos produtos associados na encomenda de festas do banco de dados.
--Em uma encomenda deve ser armenado o fornecedor da encomenda, o nome do produto encomendado, a data do contrato, o preco do fornecimento,
--a quantidade do produto encomendado, a data e a hora da entrega, o local da entrega e a nota fiscal associada a encomenda para posterior
--pagamento.
CREATE TABLE ENCOMENDA (
    FORNECEDOR_ALIMENTOS_CNPJ CHAR(18) NOT NULL,
    PRODUTO_NOME VARCHAR2(40) NOT NULL,
    DATA_CONTRATO DATE DEFAULT SYSDATE NOT NULL,
    PRECO_FORNECIMENTO NUMBER(12,2) DEFAULT 0 NOT NULL,
    QUANTIDADE_PRODUTO NUMBER(12) DEFAULT 0 NOT NULL,
    DATA_HORA_ENTREGA DATE NOT NULL,
    LOCAL_ENTREGA VARCHAR2(240) NOT NULL,
    NOTA_FISCAL_NRO_FISCAL VARCHAR2(44),
    CONSTRAINT PK_ENCOMENDA PRIMARY KEY(FORNECEDOR_ALIMENTOS_CNPJ, PRODUTO_NOME, DATA_CONTRATO), --chave primaria da tabela
    CONSTRAINT FK_ENCOMENDA_FORN_ALIMENTOS FOREIGN KEY(FORNECEDOR_ALIMENTOS_CNPJ)
                REFERENCES FORNECEDOR_ALIMENTOS(CNPJ)
                ON DELETE CASCADE,
    CONSTRAINT FK_ENCOMENDA_PRODUTO FOREIGN KEY(PRODUTO_NOME)
                REFERENCES PRODUTO(NOME)
                ON DELETE CASCADE,
    CONSTRAINT FK_ENCOMENDA_NOTA_FISCAL FOREIGN KEY(NOTA_FISCAL_NRO_FISCAL)
                REFERENCES NOTA_FISCAL(NRO_FISCAL)
                ON DELETE SET NULL,
    CONSTRAINT CK1_ENCOMENDA CHECK(PRECO_FORNECIMENTO >= 0), --checando validade do preco do fornecimento, que deve ser positivo
    CONSTRAINT CK2_ENCOMENDA CHECK(QUANTIDADE_PRODUTO >= 0) --checando validade de quantidade, pois deve ser um valor positivo
);

CREATE OR REPLACE TRIGGER TRIGGER_FESTA_ENCOMENDA --VERIFICAR SE EXISTE PELO MENOS UMA FESTA NA DATA DESTA ENCOMENDA
    BEFORE INSERT OR UPDATE ON ENCOMENDA
    FOR EACH ROW
    DECLARE
        NUMBER_AUX NUMBER(12);
    BEGIN
        SELECT COUNT(*) INTO NUMBER_AUX FROM FESTA 
            WHERE  (:NEW.LOCAL_ENTREGA = ENDERECO)
            AND TO_CHAR(:NEW.DATA_HORA_ENTREGA, 'DD-MM-YYYY') = TO_CHAR(DATA_HORA, 'DD-MM-YYYY');
                    
        IF NUMBER_AUX = 0 THEN
            RAISE_APPLICATION_ERROR (-20008, 'Nao existe nenhuma festa marcada para esta data neste local!');
            
        END IF;
    END;
/

--Criando TRIGGER de banco para atualizar o preco total da nota fiscal vinculada, se houver, que se trata como um atributo DERIVADO
--na tabela de NOTA_FISCAL. OBS: NAO EH O MESMO ATRIBUTO DERIVADO "PRECO_TOTAL" da tabela FESTA!
CREATE OR REPLACE TRIGGER TRIGGER_PRECO_TOTAL_NOTA_FISC --ATUALIZAR PRECO TOTAL DA NOTA FISCAL VINCULADA (SE HOUVER)
    AFTER INSERT OR UPDATE OR DELETE ON ENCOMENDA
    FOR EACH ROW
    BEGIN
        --Se estamos deletando uma linha, entao teremos que subtrair o preco da linha deletada do preco total da nota_fiscal
        IF DELETING THEN
            IF :OLD.NOTA_FISCAL_NRO_FISCAL IS NOT NULL THEN
                UPDATE NOTA_FISCAL SET PRECO_TOTAL = (PRECO_TOTAL - :OLD.PRECO_FORNECIMENTO)
                    WHERE (:OLD.NOTA_FISCAL_NRO_FISCAL = NRO_FISCAL);
            END IF;
        
        --Se estamos inserindo uma linha, entao teremos que somar o preco da linha deletada do preco total da nota_fiscal
        ELSIF INSERTING THEN
            IF :NEW.NOTA_FISCAL_NRO_FISCAL IS NOT NULL THEN
                UPDATE NOTA_FISCAL SET PRECO_TOTAL = (PRECO_TOTAL + :NEW.PRECO_FORNECIMENTO)
                    WHERE (:NEW.NOTA_FISCAL_NRO_FISCAL = NRO_FISCAL);
            END IF;
        
        --Se estamos atualizando uma linha, entao teremos que subtrair o preco da linha antiga e somar o preco
        --da linha nova do preco total da nota_fiscal, para garantir consistencia
        ELSIF UPDATING THEN
            IF :OLD.NOTA_FISCAL_NRO_FISCAL IS NOT NULL THEN
                UPDATE NOTA_FISCAL SET PRECO_TOTAL = (PRECO_TOTAL - :OLD.PRECO_FORNECIMENTO)
                    WHERE (:OLD.NOTA_FISCAL_NRO_FISCAL = NRO_FISCAL);
            END IF;
            IF :NEW.NOTA_FISCAL_NRO_FISCAL IS NOT NULL THEN
                UPDATE NOTA_FISCAL SET PRECO_TOTAL = (PRECO_TOTAL + :NEW.PRECO_FORNECIMENTO)
                    WHERE (:NEW.NOTA_FISCAL_NRO_FISCAL = NRO_FISCAL);
            END IF;
        END IF;
    END;
/

--Auxiliar drop tables, triggers ou sequences para teste durante fase de desenvolvimento
--SELECT 'DROP TABLE '||TABLE_NAME||' CASCADE CONSTRAINTS;' FROM USER_TABLES;

--SELECT 'DROP TRIGGER '||TRIGGER_NAME||';' FROM USER_TRIGGERS;

--SELECT 'DROP SEQUENCE '||SEQUENCE_NAME||';' FROM USER_SEQUENCES;

--A seguir, realizaremos muitos e muitos inserts para testar consistencia de TRIGGERS de banco, SEQUENCES, CHECKS, VALIDADE DE ATRIBUTOS,
--preenchendo ao mesmo tempo as tabelas com mais de DEZ linhas por tabela, para garantir corretude de implementacao.
--Em cada bloco de inserts, demarcaremos a qual tabela esses inserts estao sendo realizados.

/*--------------------------------------------CLIENTE--------------------------------------------------------*/

INSERT INTO CLIENTE VALUES ('031.822.370-00', 'CLIENTE 1', 'CLIENTE1@GMAIL.COM', 'EMPRESA 1', '11911111111', NULL);
INSERT INTO CLIENTE VALUES ('031.822.370-01', 'CLIENTE 2', 'CLIENTE2@GMAIL.COM', 'EMPRESA 2', '11922222222', '11922222223');
INSERT INTO CLIENTE VALUES ('031.822.370-02', 'CLIENTE 3', 'CLIENTE3@GMAIL.COM', 'EMPRESA 3', '11933333333', '11933333334');
INSERT INTO CLIENTE VALUES ('031.822.370-03', 'CLIENTE 4', 'CLIENTE4@GMAIL.COM', 'EMPRESA 4', '11944444444', '11944444445');
INSERT INTO CLIENTE VALUES ('031.822.370-04', 'CLIENTE 5', 'CLIENTE5@GMAIL.COM', 'EMPRESA 5', '11955555555', '11955555556');
INSERT INTO CLIENTE VALUES ('031.822.370-05', 'CLIENTE 6', 'CLIENTE6@GMAIL.COM', NULL, '11966666666', '11966666667');
INSERT INTO CLIENTE VALUES ('031.822.370-06', 'CLIENTE 7', 'CLIENTE7@GMAIL.COM', 'EMPRESA 7', '11977777777', NULL);
INSERT INTO CLIENTE VALUES ('031.822.370-07', 'CLIENTE 8', 'CLIENTE8@GMAIL.COM', NULL, '11988888888', NULL);
INSERT INTO CLIENTE VALUES ('031.822.370-08', 'CLIENTE 9', 'CLIENTE9@GMAIL.COM', NULL, '11999999999', NULL);
INSERT INTO CLIENTE VALUES ('031.822.370-09', 'CLIENTE 10', 'CLIENTE10@GMAIL.COM', 'EMPRESA 10', '12910101010', NULL);


/*--------------------------------------------ENDERECO_CLIENTE--------------------------------------------*/

INSERT INTO ENDERECO_CLIENTE (CLIENTE_CPF, NRO, CIDADE, COMPLEMENTO, RUA, BAIRRO) 
    VALUES('031.822.370-00',  11, 'CIDADE 1', 'APT 1', 'RUA 1', 'BAIRRO 1');

INSERT INTO ENDERECO_CLIENTE (CLIENTE_CPF, NRO, CIDADE, COMPLEMENTO, RUA, BAIRRO) 
    VALUES('031.822.370-00', 22, 'CIDADE 1', 'APT 2', 'RUA 2', 'BAIRRO 2');

INSERT INTO ENDERECO_CLIENTE (CLIENTE_CPF, NRO, CIDADE, COMPLEMENTO, RUA, BAIRRO) 
    VALUES('031.822.370-01', 33, 'CIDADE 2', 'APT 3', 'RUA 3', 'BAIRRO 3');

INSERT INTO ENDERECO_CLIENTE (CLIENTE_CPF, NRO, CIDADE, COMPLEMENTO, RUA, BAIRRO) 
    VALUES('031.822.370-01', 44, 'CIDADE 3', 'APT 4', 'RUA 4', 'BAIRRO 4');

INSERT INTO ENDERECO_CLIENTE (CLIENTE_CPF, NRO, CIDADE, COMPLEMENTO, RUA, BAIRRO) 
    VALUES('031.822.370-02', 55, 'CIDADE 3', 'APT 5', 'RUA 5', 'BAIRRO 5');

INSERT INTO ENDERECO_CLIENTE (CLIENTE_CPF, NRO, CIDADE, COMPLEMENTO, RUA, BAIRRO) 
    VALUES('031.822.370-02', 66, 'CIDADE 3', 'APT 6', 'RUA 6', 'BAIRRO 6');

INSERT INTO ENDERECO_CLIENTE (CLIENTE_CPF, NRO, CIDADE, COMPLEMENTO, RUA, BAIRRO) 
    VALUES('031.822.370-03', 77, 'CIDADE 4', 'APT 7', 'RUA 7', 'BAIRRO 7');

INSERT INTO ENDERECO_CLIENTE (CLIENTE_CPF, NRO, CIDADE, COMPLEMENTO, RUA, BAIRRO) 
    VALUES('031.822.370-03', 88, 'CIDADE 4', 'APT 8', 'RUA 8', 'BAIRRO 8');

INSERT INTO ENDERECO_CLIENTE (CLIENTE_CPF, NRO, CIDADE, COMPLEMENTO, RUA, BAIRRO) 
    VALUES('031.822.370-04', 99, 'CIDADE 4', 'APT 9', 'RUA 9', 'BAIRRO 9');

INSERT INTO ENDERECO_CLIENTE (CLIENTE_CPF, NRO, CIDADE, COMPLEMENTO, RUA, BAIRRO) 
    VALUES('031.822.370-04', 1010, 'CIDADE 4', 'APT 10', 'RUA 10', 'BAIRRO 10');

INSERT INTO ENDERECO_CLIENTE (CLIENTE_CPF, NRO, CIDADE, COMPLEMENTO, RUA, BAIRRO) 
    VALUES('031.822.370-05', 1111, 'CIDADE 5', 'APT 11', 'RUA 11', 'BAIRRO 11');

INSERT INTO ENDERECO_CLIENTE (CLIENTE_CPF, NRO, CIDADE, COMPLEMENTO, RUA, BAIRRO) 
    VALUES('031.822.370-05', 1212, 'CIDADE 5', 'APT 12', 'RUA 12', 'BAIRRO 12');

INSERT INTO ENDERECO_CLIENTE (CLIENTE_CPF, NRO, CIDADE, COMPLEMENTO, RUA, BAIRRO) 
    VALUES('031.822.370-06', 1313, 'CIDADE 6', 'APT 13', 'RUA 13', 'BAIRRO 13');

INSERT INTO ENDERECO_CLIENTE (CLIENTE_CPF, NRO, CIDADE, COMPLEMENTO, RUA, BAIRRO) 
    VALUES('031.822.370-07', 1414, 'CIDADE 6', 'APT 14', 'RUA 14', 'BAIRRO 14');

INSERT INTO ENDERECO_CLIENTE (CLIENTE_CPF, NRO, CIDADE, COMPLEMENTO, RUA, BAIRRO) 
    VALUES('031.822.370-08', 1515, 'CIDADE 6', 'APT 15', 'RUA 15', 'BAIRRO 15');

    
/*------------------------------------------------FESTA--------------------------------------------------------*/

INSERT INTO FESTA (NRO_CONVIDADOS, ENDERECO, PRECO_FESTA, TIPO, DATA_HORA, PRECO_TOTAL, CLIENTE_CPF)
    VALUES(2000,'ENDERECO 0', 2000.00, 'CASAMENTO', TO_DATE('2018/09/01 20:00:00', 'YYYY/MM/DD HH24:MI:SS'), 2000.00, '031.822.370-00');
INSERT INTO FESTA (NRO_CONVIDADOS, ENDERECO, PRECO_FESTA, TIPO, DATA_HORA, PRECO_TOTAL, CLIENTE_CPF)
    VALUES(100,'ENDERECO 1', 100.00, 'CASAMENTO', TO_DATE('2018/09/01 20:00:00', 'YYYY/MM/DD HH24:MI:SS'), 200.00, '031.822.370-00');
INSERT INTO FESTA (NRO_CONVIDADOS, ENDERECO, PRECO_FESTA, TIPO, DATA_HORA, PRECO_TOTAL, CLIENTE_CPF)
    VALUES(200,'ENDERECO 2', 200.00, 'FORMATURA', TO_DATE('2018/09/02 21:00:00', 'YYYY/MM/DD HH24:MI:SS'), 300.00, '031.822.370-01');
INSERT INTO FESTA (NRO_CONVIDADOS, ENDERECO, PRECO_FESTA, TIPO, DATA_HORA, PRECO_TOTAL, CLIENTE_CPF)
    VALUES(300,'ENDERECO 3', 300.00, 'CASAMENTO', TO_DATE('2018/09/03 22:00:00', 'YYYY/MM/DD HH24:MI:SS'), 400.00, '031.822.370-01');
INSERT INTO FESTA (NRO_CONVIDADOS, ENDERECO, PRECO_FESTA, TIPO, DATA_HORA, PRECO_TOTAL, CLIENTE_CPF)
    VALUES(400,'ENDERECO 4', 400.00, 'CASAMENTO', TO_DATE('2018/09/04 20:30:00', 'YYYY/MM/DD HH24:MI:SS'), 500.00, '031.822.370-02');
INSERT INTO FESTA (NRO_CONVIDADOS, ENDERECO, PRECO_FESTA, TIPO, DATA_HORA, PRECO_TOTAL, CLIENTE_CPF)
    VALUES(500,'ENDERECO 5', 500.00, 'FORMATURA', TO_DATE('2018/09/05 20:40:00', 'YYYY/MM/DD HH24:MI:SS'), 600.00, '031.822.370-03');
INSERT INTO FESTA (NRO_CONVIDADOS, ENDERECO, PRECO_FESTA, TIPO, DATA_HORA, PRECO_TOTAL, CLIENTE_CPF)
    VALUES(600,'ENDERECO 6', 600.00, 'CASAMENTO', TO_DATE('2018/09/06 20:50:00', 'YYYY/MM/DD HH24:MI:SS'), 700.00, '031.822.370-03');
INSERT INTO FESTA (NRO_CONVIDADOS, ENDERECO, PRECO_FESTA, TIPO, DATA_HORA, PRECO_TOTAL, CLIENTE_CPF)
    VALUES(700,'ENDERECO 7', 700.00, 'FORMATURA', TO_DATE('2018/09/07 21:00:00', 'YYYY/MM/DD HH24:MI:SS'), 800.00, '031.822.370-04');
INSERT INTO FESTA (NRO_CONVIDADOS, ENDERECO, PRECO_FESTA, TIPO, DATA_HORA, PRECO_TOTAL, CLIENTE_CPF)
    VALUES(800,'ENDERECO 8', 800.00, 'CASAMENTO', TO_DATE('2018/09/08 22:00:00', 'YYYY/MM/DD HH24:MI:SS'), 900.00, '031.822.370-05');
INSERT INTO FESTA (NRO_CONVIDADOS, ENDERECO, PRECO_FESTA, TIPO, DATA_HORA, PRECO_TOTAL, CLIENTE_CPF)
    VALUES(900,'ENDERECO 9', 900.00, 'CASAMENTO', TO_DATE('2018/09/09 23:00:00', 'YYYY/MM/DD HH24:MI:SS'), 1000.00, '031.822.370-05');
INSERT INTO FESTA (NRO_CONVIDADOS, ENDERECO, PRECO_FESTA, TIPO, DATA_HORA, PRECO_TOTAL, CLIENTE_CPF)
    VALUES(1000,'ENDERECO 10', 1000.00, 'FORMATURA', TO_DATE('2018/09/10 21:30:00', 'YYYY/MM/DD HH24:MI:SS'), 1100.00, '031.822.370-06');
INSERT INTO FESTA (NRO_CONVIDADOS, ENDERECO, PRECO_FESTA, TIPO, DATA_HORA, PRECO_TOTAL, CLIENTE_CPF)
    VALUES(1100,'ENDERECO 11', 1100.00, 'CASAMENTO', TO_DATE('2018/09/11 21:50:00', 'YYYY/MM/DD HH24:MI:SS'), 1200.00, '031.822.370-07');
INSERT INTO FESTA (NRO_CONVIDADOS, ENDERECO, PRECO_FESTA, TIPO, DATA_HORA, PRECO_TOTAL, CLIENTE_CPF)    
    VALUES(1200,'ENDERECO 12', 1200.00, 'FORMATURA', TO_DATE('2018/09/12 20:50:00', 'YYYY/MM/DD HH24:MI:SS'), 1300.00, '031.822.370-07');
INSERT INTO FESTA (NRO_CONVIDADOS, ENDERECO, PRECO_FESTA, TIPO, DATA_HORA, PRECO_TOTAL, CLIENTE_CPF)
    VALUES(1300,'ENDERECO 13', 1300.00, 'FORMATURA', TO_DATE('2018/09/13 22:40:00', 'YYYY/MM/DD HH24:MI:SS'), 1400.00, '031.822.370-08');
INSERT INTO FESTA (NRO_CONVIDADOS, ENDERECO, PRECO_FESTA, TIPO, DATA_HORA, PRECO_TOTAL, CLIENTE_CPF)
    VALUES(1400,'ENDERECO 14', 1400.00, 'FORMATURA', TO_DATE('2018/09/14 22:50:00', 'YYYY/MM/DD HH24:MI:SS'), 1500.00, '031.822.370-09');


/*--------------------------------------------UTENSILIO--------------------------------------------------------*/

INSERT INTO UTENSILIO (NOME, QTD_ESTOQUE, TIPO)
    VALUES ('COLHER 1', 35, 'TALHER');
    
INSERT INTO UTENSILIO (NOME, QTD_ESTOQUE, TIPO)
    VALUES ('COLHER 2', 45, 'TALHER');
    
INSERT INTO UTENSILIO (NOME, QTD_ESTOQUE, TIPO)
    VALUES ('FACA 1', 500, 'TALHER');
    
INSERT INTO UTENSILIO (NOME, QTD_ESTOQUE, TIPO)
    VALUES ('FACA 2', 500,'TALHER');
    
INSERT INTO UTENSILIO (NOME, QTD_ESTOQUE, TIPO)
    VALUES ('GARFO 1', 500, 'TALHER');
    
INSERT INTO UTENSILIO (NOME, QTD_ESTOQUE, TIPO)
    VALUES ('GARFO 2', 500, 'TALHER');
    
INSERT INTO UTENSILIO (NOME, QTD_ESTOQUE, TIPO)
    VALUES ('GUARDANAPO 1', 345, 'GUARDANAPOPANO');
    
INSERT INTO UTENSILIO (NOME, QTD_ESTOQUE, TIPO)
    VALUES ('TACA 1', 600, 'TACA');
    
INSERT INTO UTENSILIO (NOME, QTD_ESTOQUE, TIPO)
    VALUES ('PRATO 1', 300, 'PRATO');
    
INSERT INTO UTENSILIO (NOME, QTD_ESTOQUE, TIPO)
    VALUES ('PRATO 2', 300, 'PRATO');


/*-----------------------------------------------FUNCIONARIO-------------------------------------------------------*/

INSERT INTO FUNCIONARIO (CPF, NOME, EMAIL, TELEFONE1, TELEFONE2, FUNCAO, FUNCIONARIO_GERENTE_CPF)
    VALUES ('031.822.370-10', 'NOME 1', 'EMAIL1@GMAIL.COM', 1111111, 11111112, 'COPEIRO', NULL);

INSERT INTO FUNCIONARIO (CPF, NOME, EMAIL, TELEFONE1, TELEFONE2, FUNCAO, FUNCIONARIO_GERENTE_CPF)
    VALUES ('031.822.370-11', 'NOME 2', 'EMAIL2@GMAIL.COM', 22222222, NULL, 'COPEIRO', '031.822.370-10');
    
INSERT INTO FUNCIONARIO (CPF, NOME, EMAIL, TELEFONE1, TELEFONE2, FUNCAO, FUNCIONARIO_GERENTE_CPF)
    VALUES ('031.822.370-12', 'NOME 3', 'EMAIL3@GMAIL.COM', 33333333, 33333334, 'CONFEITEIRO', NULL);
    
INSERT INTO FUNCIONARIO (CPF, NOME, EMAIL, TELEFONE1, TELEFONE2, FUNCAO, FUNCIONARIO_GERENTE_CPF)
    VALUES ('031.822.370-13', 'NOME 4', 'EMAIL4@GMAIL.COM', 44444444, NULL, 'CONFEITEIRO', '031.822.370-12');
    
INSERT INTO FUNCIONARIO (CPF, NOME, EMAIL, TELEFONE1, TELEFONE2, FUNCAO, FUNCIONARIO_GERENTE_CPF)
    VALUES ('031.822.370-14', 'NOME 5', 'EMAIL5@GMAIL.COM', 55555555, 55555556, 'GARCOM', NULL);
    
INSERT INTO FUNCIONARIO (CPF, NOME, EMAIL, TELEFONE1, TELEFONE2, FUNCAO, FUNCIONARIO_GERENTE_CPF)
    VALUES ('031.822.370-15', 'NOME 6', 'EMAIL6@GMAIL.COM', 66666666, NULL, 'GARCOM', '031.822.370-14');

INSERT INTO FUNCIONARIO (CPF, NOME, EMAIL, TELEFONE1, TELEFONE2, FUNCAO, FUNCIONARIO_GERENTE_CPF)
    VALUES ('031.822.370-16', 'NOME 7', 'EMAIL7@GMAIL.COM', 77777777, 77777778, 'COZINHEIRO', NULL);
    
INSERT INTO FUNCIONARIO (CPF, NOME, EMAIL, TELEFONE1, TELEFONE2, FUNCAO, FUNCIONARIO_GERENTE_CPF)
    VALUES ('031.822.370-17', 'NOME 8', 'EMAIL8@GMAIL.COM', 888888888, NULL, 'COZINHEIRO', '031.822.370-16');
    
INSERT INTO FUNCIONARIO (CPF, NOME, EMAIL, TELEFONE1, TELEFONE2, FUNCAO, FUNCIONARIO_GERENTE_CPF)
    VALUES ('031.822.370-18', 'NOME 9', 'EMAIL9@GMAIL.COM', 999999999, 9999999910, 'BARMAN', '031.822.370-17');
    
INSERT INTO FUNCIONARIO (CPF, NOME, EMAIL, TELEFONE1, TELEFONE2, FUNCAO, FUNCIONARIO_GERENTE_CPF)
    VALUES ('031.822.370-19', 'NOME 10', 'EMAIL10@GMAIL.COM', 1010101010, NULL, 'BARMAN', '031.822.370-18');


/*------------------------------FUNCIONARIO_FESTA------------------------------------*/

INSERT INTO FUNCIONARIO_FESTA(FUNCIONARIO_CPF, FESTA_NRO_REGISTRO, PRECO_FUNCIONARIO)
    VALUES('031.822.370-12', 1, 111.11);
--INSERT INTO FUNCIONARIO_FESTA(FUNCIONARIO_CPF, FESTA_NRO_REGISTRO, PRECO_FUNCIONARIO)--TESTE DE INSERCAO NA MESMA DATA
--    VALUES('031.822.370-12', 2, 111.11);
--INSERT INTO FUNCIONARIO_FESTA(FUNCIONARIO_CPF, FESTA_NRO_REGISTRO, PRECO_FUNCIONARIO)--TESTE INSERCAO DE COPEIRO EM CASAMENTO
--    VALUES('031.822.370-10', 1, 111.11);
INSERT INTO FUNCIONARIO_FESTA(FUNCIONARIO_CPF, FESTA_NRO_REGISTRO, PRECO_FUNCIONARIO)
    VALUES('031.822.370-10', 3, 222.22);
INSERT INTO FUNCIONARIO_FESTA(FUNCIONARIO_CPF, FESTA_NRO_REGISTRO, PRECO_FUNCIONARIO)
    VALUES('031.822.370-13', 2, 333.33);
INSERT INTO FUNCIONARIO_FESTA(FUNCIONARIO_CPF, FESTA_NRO_REGISTRO, PRECO_FUNCIONARIO)
    VALUES('031.822.370-14', 4, 444.44);
INSERT INTO FUNCIONARIO_FESTA(FUNCIONARIO_CPF, FESTA_NRO_REGISTRO, PRECO_FUNCIONARIO)
    VALUES('031.822.370-16', 5, 555.55);
--INSERT INTO FUNCIONARIO_FESTA(FUNCIONARIO_CPF, FESTA_NRO_REGISTRO, PRECO_FUNCIONARIO)--TESTE INSERCAO DE GARCOM EM FORMATURA
--    VALUES('031.822.370-15', 6, 555.55);
INSERT INTO FUNCIONARIO_FESTA(FUNCIONARIO_CPF, FESTA_NRO_REGISTRO, PRECO_FUNCIONARIO)
    VALUES('031.822.370-15', 7, 666.66);
INSERT INTO FUNCIONARIO_FESTA(FUNCIONARIO_CPF, FESTA_NRO_REGISTRO, PRECO_FUNCIONARIO)
    VALUES('031.822.370-10', 6, 777.77);
INSERT INTO FUNCIONARIO_FESTA(FUNCIONARIO_CPF, FESTA_NRO_REGISTRO, PRECO_FUNCIONARIO)
    VALUES('031.822.370-10', 8, 888.88);
INSERT INTO FUNCIONARIO_FESTA(FUNCIONARIO_CPF, FESTA_NRO_REGISTRO, PRECO_FUNCIONARIO)
    VALUES('031.822.370-16', 9, 999.99);
INSERT INTO FUNCIONARIO_FESTA(FUNCIONARIO_CPF, FESTA_NRO_REGISTRO, PRECO_FUNCIONARIO)
    VALUES('031.822.370-15', 9, 999.99);
INSERT INTO FUNCIONARIO_FESTA(FUNCIONARIO_CPF, FESTA_NRO_REGISTRO, PRECO_FUNCIONARIO)
    VALUES('031.822.370-19', 10, 101.10);
    

/*-------------------------------UTENSILIO_FESTA------------------------------------*/

INSERT INTO UTENSILIO_FESTA(FESTA_NRO_REGISTRO, UTENSILIO_NOME, QUANTIDADE)
    VALUES(1, 'COLHER 1', 10);
--INSERT INTO UTENSILIO_FESTA(FESTA_NRO_REGISTRO, UTENSILIO_NOME, QUANTIDADE)--caso em que nao ha a quantidade no estoque
--    VALUES(2, 'COLHER 2', 150);
INSERT INTO UTENSILIO_FESTA(FESTA_NRO_REGISTRO, UTENSILIO_NOME, QUANTIDADE)
    VALUES(3, 'FACA 1', 100);
--INSERT INTO UTENSILIO_FESTA(FESTA_NRO_REGISTRO, UTENSILIO_NOME, QUANTIDADE)--caso em que nao ha a quantidade no estoque
--    VALUES(4, 'FACA 2', 1001);
--INSERT INTO UTENSILIO_FESTA(FESTA_NRO_REGISTRO, UTENSILIO_NOME, QUANTIDADE)--caso em que nao ha a quantidade no estoque
--    VALUES(5, 'GARFO 1', 10000);
INSERT INTO UTENSILIO_FESTA(FESTA_NRO_REGISTRO, UTENSILIO_NOME, QUANTIDADE)
    VALUES(6, 'GARFO 2', 10);
INSERT INTO UTENSILIO_FESTA(FESTA_NRO_REGISTRO, UTENSILIO_NOME, QUANTIDADE)
    VALUES(7, 'GUARDANAPO 1', 100);
INSERT INTO UTENSILIO_FESTA(FESTA_NRO_REGISTRO, UTENSILIO_NOME, QUANTIDADE)
    VALUES(8, 'TACA 1', 150);
--INSERT INTO UTENSILIO_FESTA(FESTA_NRO_REGISTRO, UTENSILIO_NOME, QUANTIDADE)--caso em que nao ha a quantidade no estoque
--    VALUES(9, 'PRATO 1', 371);
--INSERT INTO UTENSILIO_FESTA(FESTA_NRO_REGISTRO, UTENSILIO_NOME, QUANTIDADE)--caso em que nao ha a quantidade no estoque
--    VALUES(10, 'PRATO 2', 697);


/* ---------------------------------------DOCE----------------------------------------------------*/

INSERT INTO DOCE(NOME, MODELO, PRECO_UNIDADE, DESCRICAO)
    VALUES('DOCE 1', 'MODELO DOCE 1', 1, 'DESCRICAO DOCE 1');
INSERT INTO DOCE(NOME, MODELO, PRECO_UNIDADE, DESCRICAO)
    VALUES('DOCE 2', 'MODELO DOCE 2', 2, 'DESCRICAO DOCE 2');
INSERT INTO DOCE(NOME, MODELO, PRECO_UNIDADE, DESCRICAO)
    VALUES('DOCE 3', 'MODELO DOCE 3', 3, 'DESCRICAO DOCE 3');
INSERT INTO DOCE(NOME, MODELO, PRECO_UNIDADE, DESCRICAO)
    VALUES('DOCE 4', 'MODELO DOCE 4', 4, 'DESCRICAO DOCE 4');
INSERT INTO DOCE(NOME, MODELO, PRECO_UNIDADE, DESCRICAO)
    VALUES('DOCE 5', 'MODELO DOCE 5', 5, 'DESCRICAO DOCE 5');
INSERT INTO DOCE(NOME, MODELO, PRECO_UNIDADE, DESCRICAO)
    VALUES('DOCE 6', 'MODELO DOCE 6', 6, 'DESCRICAO DOCE 6');
INSERT INTO DOCE(NOME, MODELO, PRECO_UNIDADE, DESCRICAO)
    VALUES('DOCE 7', 'MODELO DOCE 7', 7, 'DESCRICAO DOCE 7');
INSERT INTO DOCE(NOME, MODELO, PRECO_UNIDADE, DESCRICAO)
    VALUES('DOCE 8', 'MODELO DOCE 8', 8, 'DESCRICAO DOCE 8');
INSERT INTO DOCE(NOME, MODELO, PRECO_UNIDADE, DESCRICAO)
    VALUES('DOCE 9', 'MODELO DOCE 9', 9, 'DESCRICAO DOCE 9');
INSERT INTO DOCE(NOME, MODELO, PRECO_UNIDADE, DESCRICAO)
    VALUES('DOCE 10', 'MODELO DOCE 10', 10, 'DESCRICAO DOCE 10');


/*-----------------------------------DOCE_FESTA-------------------------------*/

INSERT INTO DOCE_FESTA(DOCE_NOME, FESTA_NRO_REGISTRO, QUANTIDADE)
    VALUES('DOCE 1', 1, 100);
INSERT INTO DOCE_FESTA(DOCE_NOME, FESTA_NRO_REGISTRO, QUANTIDADE)--teste de incremento do preco total
    VALUES('DOCE 2', 1, 100);
--INSERT INTO DOCE_FESTA(DOCE_NOME, FESTA_NRO_REGISTRO, QUANTIDADE)--erro: inserindo em formatura
--    VALUES('DOCE 2', 3, 200);
INSERT INTO DOCE_FESTA(DOCE_NOME, FESTA_NRO_REGISTRO, QUANTIDADE)
    VALUES('DOCE 3', 2, 300);
INSERT INTO DOCE_FESTA(DOCE_NOME, FESTA_NRO_REGISTRO, QUANTIDADE)
    VALUES('DOCE 4', 4, 400);
--INSERT INTO DOCE_FESTA(DOCE_NOME, FESTA_NRO_REGISTRO, QUANTIDADE)--erro: inserindo em formatura
--    VALUES('DOCE 5', 3, 500);
INSERT INTO DOCE_FESTA(DOCE_NOME, FESTA_NRO_REGISTRO, QUANTIDADE)
    VALUES('DOCE 6', 5, 600);
--INSERT INTO DOCE_FESTA(DOCE_NOME, FESTA_NRO_REGISTRO, QUANTIDADE)--erro: inserindo em formatura
--    VALUES('DOCE 7', 8, 700);
INSERT INTO DOCE_FESTA(DOCE_NOME, FESTA_NRO_REGISTRO, QUANTIDADE)
    VALUES('DOCE 8', 7, 800);
INSERT INTO DOCE_FESTA(DOCE_NOME, FESTA_NRO_REGISTRO, QUANTIDADE)
    VALUES('DOCE 9', 9, 900);
--INSERT INTO DOCE_FESTA(DOCE_NOME, FESTA_NRO_REGISTRO, QUANTIDADE)--erro: inserindo em formatura
--    VALUES('DOCE 10', 11, 1000);

/*---------------------------------BOLO---------------------------------------*/

INSERT INTO BOLO(NOME, MODELO, PRECO, DESCRICAO)
    VALUES('BOLO 1', 'MODELO BOLO 1', 1, 'DESCRICAO BOLO 1');
INSERT INTO BOLO(NOME, MODELO, PRECO, DESCRICAO)
    VALUES('BOLO 2', 'MODELO BOLO 2', 2, 'DESCRICAO BOLO 2');
INSERT INTO BOLO(NOME, MODELO, PRECO, DESCRICAO)
    VALUES('BOLO 3', 'MODELO BOLO 3', 3, 'DESCRICAO BOLO 3');
INSERT INTO BOLO(NOME, MODELO, PRECO, DESCRICAO)
    VALUES('BOLO 4', 'MODELO BOLO 4', 4, 'DESCRICAO BOLO 4');
INSERT INTO BOLO(NOME, MODELO, PRECO, DESCRICAO)
    VALUES('BOLO 5', 'MODELO BOLO 5', 5, 'DESCRICAO BOLO 5');
INSERT INTO BOLO(NOME, MODELO, PRECO, DESCRICAO)
    VALUES('BOLO 6', 'MODELO BOLO 6', 6, 'DESCRICAO BOLO 6');
INSERT INTO BOLO(NOME, MODELO, PRECO, DESCRICAO)
    VALUES('BOLO 7', 'MODELO BOLO 7', 7, 'DESCRICAO BOLO 7');
INSERT INTO BOLO(NOME, MODELO, PRECO, DESCRICAO)
    VALUES('BOLO 8', 'MODELO BOLO 8', 8, 'DESCRICAO BOLO 8');
INSERT INTO BOLO(NOME, MODELO, PRECO, DESCRICAO)
    VALUES('BOLO 9', 'MODELO BOLO 9', 9, 'DESCRICAO BOLO 9');
INSERT INTO BOLO(NOME, MODELO, PRECO, DESCRICAO)
    VALUES('BOLO 10', 'MODELO BOLO 10', 100, 'DESCRICAO BOLO 10');
INSERT INTO BOLO(NOME, MODELO, PRECO, DESCRICAO)
    VALUES('BOLO 11', 'MODELO BOLO 11', 500, 'DESCRICAO BOLO 11');
INSERT INTO BOLO(NOME, MODELO, PRECO, DESCRICAO)
    VALUES('BOLO 12', 'MODELO BOLO 12', 30, 'DESCRICAO BOLO 12');
INSERT INTO BOLO(NOME, MODELO, PRECO, DESCRICAO)
    VALUES('BOLO 13', 'MODELO BOLO 13', 440, 'DESCRICAO BOLO 13');
INSERT INTO BOLO(NOME, MODELO, PRECO, DESCRICAO)
    VALUES('BOLO 14', 'MODELO BOLO 14', 410, 'DESCRICAO BOLO 14');
INSERT INTO BOLO(NOME, MODELO, PRECO, DESCRICAO)
    VALUES('BOLO 15', 'MODELO BOLO 15', 210, 'DESCRICAO BOLO 15');
INSERT INTO BOLO(NOME, MODELO, PRECO, DESCRICAO)
    VALUES('BOLO 16', 'MODELO BOLO 16', 20, 'DESCRICAO BOLO 16');

/*-----------------------------------BOLO_FESTA--------------------------------------*/

INSERT INTO BOLO_FESTA(BOLO_NOME, FESTA_NRO_REGISTRO)
    VALUES('BOLO 1', 1);
--INSERT INTO BOLO_FESTA(BOLO_NOME, FESTA_NRO_REGISTRO)--erro: inserindo em formatura
--    VALUES('BOLO 2', 3);
INSERT INTO BOLO_FESTA(BOLO_NOME, FESTA_NRO_REGISTRO)
    VALUES('BOLO 3', 4);
INSERT INTO BOLO_FESTA(BOLO_NOME, FESTA_NRO_REGISTRO)
    VALUES('BOLO 4', 5);
--INSERT INTO BOLO_FESTA(BOLO_NOME, FESTA_NRO_REGISTRO)--erro: inserindo em formatura
--    VALUES('BOLO 5', 6);
INSERT INTO BOLO_FESTA(BOLO_NOME, FESTA_NRO_REGISTRO)
    VALUES('BOLO 6', 7);
--INSERT INTO BOLO_FESTA(BOLO_NOME, FESTA_NRO_REGISTRO)--erro: inserindo em formatura
--    VALUES('BOLO 7', 8);
INSERT INTO BOLO_FESTA(BOLO_NOME, FESTA_NRO_REGISTRO)
    VALUES('BOLO 8', 9);
INSERT INTO BOLO_FESTA(BOLO_NOME, FESTA_NRO_REGISTRO)
    VALUES('BOLO 9', 10);
--INSERT INTO BOLO_FESTA(BOLO_NOME, FESTA_NRO_REGISTRO)--erro: inserindo em formatura
--    VALUES('BOLO 10', 3);
INSERT INTO BOLO_FESTA(BOLO_NOME, FESTA_NRO_REGISTRO)
    VALUES('BOLO 11', 1);
INSERT INTO BOLO_FESTA(BOLO_NOME, FESTA_NRO_REGISTRO)
    VALUES('BOLO 12', 9);
INSERT INTO BOLO_FESTA(BOLO_NOME, FESTA_NRO_REGISTRO)
    VALUES('BOLO 13', 7);
INSERT INTO BOLO_FESTA(BOLO_NOME, FESTA_NRO_REGISTRO)
    VALUES('BOLO 14', 9);


/*---------------------------------------ALIMENTO---------------------------------------------------*/
INSERT INTO ALIMENTO VALUES('ALIMENTO 1', 1.50, 'DESCRICAO ALIMENTO 1', 'COMIDA', 0, 'ENTRADA');
INSERT INTO ALIMENTO VALUES('ALIMENTO 2', 2.50, 'DESCRICAO ALIMENTO 2', 'COMIDA', 1, 'ENTRADA');
INSERT INTO ALIMENTO VALUES('ALIMENTO 3', 3.60, 'DESCRICAO ALIMENTO 3', 'COMIDA', 0, 'ENTRADA');
INSERT INTO ALIMENTO VALUES('ALIMENTO 4', 21.00, 'DESCRICAO ALIMENTO 4', 'COMIDA', 1, 'GUARNICAO');
INSERT INTO ALIMENTO VALUES('ALIMENTO 5', 25.00, 'DESCRICAO ALIMENTO 5', 'COMIDA', 1, 'GUARNICAO');
INSERT INTO ALIMENTO VALUES('ALIMENTO 6', 10.00, 'DESCRICAO ALIMENTO 6', 'COMIDA', 0, 'GUARNICAO');
INSERT INTO ALIMENTO VALUES('ALIMENTO 7', 4.00, 'DESCRICAO ALIMENTO 7', 'COMIDA', 1, 'SALGADO');
INSERT INTO ALIMENTO VALUES('ALIMENTO 8', 5.00, 'DESCRICAO ALIMENTO 8', 'COMIDA', 1, 'SALGADO');
INSERT INTO ALIMENTO VALUES('ALIMENTO 9', 3.00, 'DESCRICAO ALIMENTO 9', 'COMIDA', 0, 'SALGADO');
INSERT INTO ALIMENTO VALUES('ALIMENTO 10', 1.00, 'DESCRICAO ALIMENTO 10', 'COMIDA', 0, 'APERITIVO');
INSERT INTO ALIMENTO VALUES('ALIMENTO 11', 2.00, 'DESCRICAO ALIMENTO 11', 'COMIDA', 1, 'APERITIVO');
INSERT INTO ALIMENTO VALUES('ALIMENTO 12', 3.50, 'DESCRICAO ALIMENTO 12', 'COMIDA', 0, 'APERITIVO');
INSERT INTO ALIMENTO VALUES('ALIMENTO 13', 3.50, 'DESCRICAO ALIMENTO 13', 'COMIDA', 1, 'MOLHO');
INSERT INTO ALIMENTO VALUES('ALIMENTO 14', 4.50, 'DESCRICAO ALIMENTO 14', 'COMIDA', 0, 'MOLHO');
INSERT INTO ALIMENTO VALUES('ALIMENTO 15', 6.50, 'DESCRICAO ALIMENTO 15', 'COMIDA', 1, 'MOLHO');
INSERT INTO ALIMENTO VALUES('ALIMENTO 16', 7.50, 'DESCRICAO ALIMENTO 16', 'COMIDA', 0, 'SOBREMESA');
INSERT INTO ALIMENTO VALUES('ALIMENTO 17', 10.99, 'DESCRICAO ALIMENTO 17', 'COMIDA', 0, 'SOBREMESA');
INSERT INTO ALIMENTO VALUES('ALIMENTO 18', 15.99, 'DESCRICAO ALIMENTO 18', 'COMIDA', 0, 'SOBREMESA');
INSERT INTO ALIMENTO VALUES('ALIMENTO 19', 50.00, 'DESCRICAO ALIMENTO 19', 'COMIDA', 0, 'PRATO PRINCIPAL');
INSERT INTO ALIMENTO VALUES('ALIMENTO 20', 40.99, 'DESCRICAO ALIMENTO 20', 'COMIDA', 0, 'PRATO PRINCIPAL');
INSERT INTO ALIMENTO VALUES('ALIMENTO 21', 32.99, 'DESCRICAO ALIMENTO 21', 'COMIDA', 0, 'PRATO PRINCIPAL');
INSERT INTO ALIMENTO VALUES('ALIMENTO 22', 13.00, 'DESCRICAO ALIMENTO 22', 'BEBIDA', 1, 'ALCOOLICA');
INSERT INTO ALIMENTO VALUES('ALIMENTO 23', 14.00, 'DESCRICAO ALIMENTO 23', 'BEBIDA', 0, 'ALCOOLICA');
INSERT INTO ALIMENTO VALUES('ALIMENTO 24', 15.99, 'DESCRICAO ALIMENTO 24', 'BEBIDA', 1, 'ALCOOLICA');
INSERT INTO ALIMENTO VALUES('ALIMENTO 25', 16.00, 'DESCRICAO ALIMENTO 25', 'BEBIDA', 1, 'NAO ALCOOLICA');
INSERT INTO ALIMENTO VALUES('ALIMENTO 26', 5.00, 'DESCRICAO ALIMENTO 26', 'BEBIDA', 1, 'NAO ALCOOLICA');
INSERT INTO ALIMENTO VALUES('ALIMENTO 27', 6.00, 'DESCRICAO ALIMENTO 27', 'BEBIDA', 1, 'NAO ALCOOLICA');

/* ----------------------------------------ALIMENTO_FESTA------------------------------------------------ */
INSERT INTO ALIMENTO_FESTA VALUES('ALIMENTO 1', 1, 5);
INSERT INTO ALIMENTO_FESTA VALUES('ALIMENTO 2', 1, 10);
INSERT INTO ALIMENTO_FESTA VALUES('ALIMENTO 5', 2, 15);
INSERT INTO ALIMENTO_FESTA VALUES('ALIMENTO 6', 2, 20);
INSERT INTO ALIMENTO_FESTA VALUES('ALIMENTO 7', 3, 25);
INSERT INTO ALIMENTO_FESTA VALUES('ALIMENTO 23', 4, 80);
INSERT INTO ALIMENTO_FESTA VALUES('ALIMENTO 15', 2, 100);
INSERT INTO ALIMENTO_FESTA VALUES('ALIMENTO 23', 2, 80);
INSERT INTO ALIMENTO_FESTA VALUES('ALIMENTO 22', 2, 150);
INSERT INTO ALIMENTO_FESTA VALUES('ALIMENTO 18', 3, 80);
INSERT INTO ALIMENTO_FESTA VALUES('ALIMENTO 25', 3, 90);
--INSERT INTO ALIMENTO_FESTA VALUES('ALIMENTO 8', 1, 30);--erro: inserindo em casamento
INSERT INTO ALIMENTO_FESTA VALUES('ALIMENTO 3', 2, 25);
INSERT INTO ALIMENTO_FESTA VALUES('ALIMENTO 5', 3, 50);
INSERT INTO ALIMENTO_FESTA VALUES('ALIMENTO 6', 4, 150);
INSERT INTO ALIMENTO_FESTA VALUES('ALIMENTO 19', 4, 5);
INSERT INTO ALIMENTO_FESTA VALUES('ALIMENTO 20', 4, 100);
INSERT INTO ALIMENTO_FESTA VALUES('ALIMENTO 5', 5, 40);
--INSERT INTO ALIMENTO_FESTA VALUES('ALIMENTO 8', 5, 80);--erro: inserindo em casamento
--INSERT INTO ALIMENTO_FESTA VALUES('ALIMENTO 3', 8, 90);--erro: inserindo em formatura
INSERT INTO ALIMENTO_FESTA VALUES('ALIMENTO 14', 8, 170);
INSERT INTO ALIMENTO_FESTA VALUES('ALIMENTO 5', 8, 30);
INSERT INTO ALIMENTO_FESTA VALUES('ALIMENTO 4', 8, 140);
INSERT INTO ALIMENTO_FESTA VALUES('ALIMENTO 18', 8, 50);
--INSERT INTO ALIMENTO_FESTA VALUES('ALIMENTO 7', 9, 30);--erro: inserindo em formatura
INSERT INTO ALIMENTO_FESTA VALUES('ALIMENTO 4', 9, 20);
INSERT INTO ALIMENTO_FESTA VALUES('ALIMENTO 1', 9, 10);
INSERT INTO ALIMENTO_FESTA VALUES('ALIMENTO 23', 10, 80);
INSERT INTO ALIMENTO_FESTA VALUES('ALIMENTO 25', 10, 100);

/*----------------------------------------PRODUTO--------------------------------------*/
INSERT INTO PRODUTO(NOME, DESCRICAO)
    VALUES('PRODUTO 1', 'DESCRICAO PRODUTO 1');
INSERT INTO PRODUTO(NOME, DESCRICAO)
    VALUES('PRODUTO 2', 'DESCRICAO PRODUTO 2');
INSERT INTO PRODUTO(NOME, DESCRICAO)
    VALUES('PRODUTO 3', 'DESCRICAO PRODUTO 3');
INSERT INTO PRODUTO(NOME, DESCRICAO)
    VALUES('PRODUTO 4', 'DESCRICAO PRODUTO 4');
INSERT INTO PRODUTO(NOME, DESCRICAO)
    VALUES('PRODUTO 5', 'DESCRICAO PRODUTO 5');
INSERT INTO PRODUTO(NOME, DESCRICAO)
    VALUES('PRODUTO 6', 'DESCRICAO PRODUTO 6');
INSERT INTO PRODUTO(NOME, DESCRICAO)
    VALUES('PRODUTO 7', 'DESCRICAO PRODUTO 7');
INSERT INTO PRODUTO(NOME, DESCRICAO)
    VALUES('PRODUTO 8', 'DESCRICAO PRODUTO 8');
INSERT INTO PRODUTO(NOME, DESCRICAO)
    VALUES('PRODUTO 9', 'DESCRICAO PRODUTO 9');
INSERT INTO PRODUTO(NOME, DESCRICAO)
    VALUES('PRODUTO 10', 'DESCRICAO PRODUTO 10');
INSERT INTO PRODUTO(NOME, DESCRICAO)
    VALUES('PRODUTO BOLO 1', 'DESCRICAO PRODUTO BOLO 1');
INSERT INTO PRODUTO(NOME, DESCRICAO)
    VALUES('PRODUTO BOLO 2', 'DESCRICAO PRODUTO BOLO 2');
INSERT INTO PRODUTO(NOME, DESCRICAO)
    VALUES('PRODUTO BOLO 3', 'DESCRICAO PRODUTO BOLO 3');
INSERT INTO PRODUTO(NOME, DESCRICAO)
    VALUES('PRODUTO BOLO 4', 'DESCRICAO PRODUTO BOLO 4');
INSERT INTO PRODUTO(NOME, DESCRICAO)
    VALUES('PRODUTO BOLO 5', 'DESCRICAO PRODUTO BOLO 5');
INSERT INTO PRODUTO(NOME, DESCRICAO)
    VALUES('PRODUTO BOLO 6', 'DESCRICAO PRODUTO BOLO 6');
INSERT INTO PRODUTO(NOME, DESCRICAO)
    VALUES('PRODUTO BOLO 7', 'DESCRICAO PRODUTO BOLO 7');
INSERT INTO PRODUTO(NOME, DESCRICAO)
    VALUES('PRODUTO BOLO 8', 'DESCRICAO PRODUTO BOLO 8');
INSERT INTO PRODUTO(NOME, DESCRICAO)
    VALUES('PRODUTO BOLO 9', 'DESCRICAO PRODUTO BOLO 9');
INSERT INTO PRODUTO(NOME, DESCRICAO)
    VALUES('PRODUTO BOLO 10', 'DESCRICAO PRODUTO BOLO 10');
INSERT INTO PRODUTO(NOME, DESCRICAO)
    VALUES('PRODUTO DOCE 1', 'DESCRICAO PRODUTO DOCE 1');
INSERT INTO PRODUTO(NOME, DESCRICAO)
    VALUES('PRODUTO DOCE 2', 'DESCRICAO PRODUTO DOCE 2');
INSERT INTO PRODUTO(NOME, DESCRICAO)
    VALUES('PRODUTO DOCE 3', 'DESCRICAO PRODUTO DOCE 3');
INSERT INTO PRODUTO(NOME, DESCRICAO)
    VALUES('PRODUTO DOCE 4', 'DESCRICAO PRODUTO DOCE 4');
INSERT INTO PRODUTO(NOME, DESCRICAO)
    VALUES('PRODUTO DOCE 5', 'DESCRICAO PRODUTO DOCE 5');
INSERT INTO PRODUTO(NOME, DESCRICAO)
    VALUES('PRODUTO DOCE 6', 'DESCRICAO PRODUTO DOCE 6');
INSERT INTO PRODUTO(NOME, DESCRICAO)
    VALUES('PRODUTO DOCE 7', 'DESCRICAO PRODUTO DOCE 7');
INSERT INTO PRODUTO(NOME, DESCRICAO)
    VALUES('PRODUTO DOCE 8', 'DESCRICAO PRODUTO DOCE 8');
INSERT INTO PRODUTO(NOME, DESCRICAO)
    VALUES('PRODUTO DOCE 9', 'DESCRICAO PRODUTO DOCE 9');
INSERT INTO PRODUTO(NOME, DESCRICAO)
    VALUES('PRODUTO DOCE 10', 'DESCRICAO PRODUTO DOCE 10');

/*---------------------------------------------PRODUTO_ALIMENTO---------------------------------------------*/
INSERT INTO PRODUTO_ALIMENTO (PRODUTO_NOME, ALIMENTO_NOME, TIPO_QUANTIDADE, QUANTIDADE)
    VALUES ('PRODUTO 1', 'ALIMENTO 1', 'KG', 200);
    
INSERT INTO PRODUTO_ALIMENTO (PRODUTO_NOME, ALIMENTO_NOME, TIPO_QUANTIDADE, QUANTIDADE)
    VALUES ('PRODUTO 2', 'ALIMENTO 1', 'KG', 300);
    
INSERT INTO PRODUTO_ALIMENTO (PRODUTO_NOME, ALIMENTO_NOME, TIPO_QUANTIDADE, QUANTIDADE)
    VALUES ('PRODUTO 2', 'ALIMENTO 2', 'L', 300);
    
INSERT INTO PRODUTO_ALIMENTO (PRODUTO_NOME, ALIMENTO_NOME, TIPO_QUANTIDADE, QUANTIDADE)
    VALUES ('PRODUTO 3', 'ALIMENTO 3', 'M', 200);
    
INSERT INTO PRODUTO_ALIMENTO (PRODUTO_NOME, ALIMENTO_NOME, TIPO_QUANTIDADE, QUANTIDADE)
    VALUES ('PRODUTO 4', 'ALIMENTO 4', 'T', 1);
    
INSERT INTO PRODUTO_ALIMENTO (PRODUTO_NOME, ALIMENTO_NOME, TIPO_QUANTIDADE, QUANTIDADE)
    VALUES ('PRODUTO 5', 'ALIMENTO 5', 'H', 3);
    
INSERT INTO PRODUTO_ALIMENTO (PRODUTO_NOME, ALIMENTO_NOME, TIPO_QUANTIDADE, QUANTIDADE)
    VALUES ('PRODUTO 6', 'ALIMENTO 6', 'MG', 200);
    
INSERT INTO PRODUTO_ALIMENTO (PRODUTO_NOME, ALIMENTO_NOME, TIPO_QUANTIDADE, QUANTIDADE)
    VALUES ('PRODUTO 7', 'ALIMENTO 7', 'KG', 1);
    
INSERT INTO PRODUTO_ALIMENTO (PRODUTO_NOME, ALIMENTO_NOME, TIPO_QUANTIDADE, QUANTIDADE)
    VALUES ('PRODUTO 8', 'ALIMENTO 8', 'T', 5);
    
INSERT INTO PRODUTO_ALIMENTO (PRODUTO_NOME, ALIMENTO_NOME, TIPO_QUANTIDADE, QUANTIDADE)
    VALUES ('PRODUTO 9', 'ALIMENTO 9', 'L', 50);
    
INSERT INTO PRODUTO_ALIMENTO (PRODUTO_NOME, ALIMENTO_NOME, TIPO_QUANTIDADE, QUANTIDADE)
    VALUES ('PRODUTO 10', 'ALIMENTO 10', 'MG', 500);
    
/*---------------------------------------------PRODUTO_BOLO-----------------------------------------------------*/
INSERT INTO PRODUTO_BOLO (PRODUTO_NOME, BOLO_NOME, TIPO_QUANTIDADE, QUANTIDADE)
    VALUES ('PRODUTO BOLO 1', 'BOLO 1', 'KG', 500);
    
INSERT INTO PRODUTO_BOLO (PRODUTO_NOME, BOLO_NOME, TIPO_QUANTIDADE, QUANTIDADE)
    VALUES ('PRODUTO BOLO 2', 'BOLO 2', 'MG', 1);
    
INSERT INTO PRODUTO_BOLO (PRODUTO_NOME, BOLO_NOME, TIPO_QUANTIDADE, QUANTIDADE)
    VALUES ('PRODUTO BOLO 3', 'BOLO 3', 'CG', 50);
    
INSERT INTO PRODUTO_BOLO (PRODUTO_NOME, BOLO_NOME, TIPO_QUANTIDADE, QUANTIDADE)
    VALUES ('PRODUTO BOLO 4', 'BOLO 4', 'DG', 24);
    
INSERT INTO PRODUTO_BOLO (PRODUTO_NOME, BOLO_NOME, TIPO_QUANTIDADE, QUANTIDADE)
    VALUES ('PRODUTO BOLO 5', 'BOLO 5', 'DAG', 28);
    
INSERT INTO PRODUTO_BOLO (PRODUTO_NOME, BOLO_NOME, TIPO_QUANTIDADE, QUANTIDADE)
    VALUES ('PRODUTO BOLO 6', 'BOLO 6', 'HECG', 100);
    
INSERT INTO PRODUTO_BOLO (PRODUTO_NOME, BOLO_NOME, TIPO_QUANTIDADE, QUANTIDADE)
    VALUES ('PRODUTO BOLO 7', 'BOLO 7', 'T', 8000);
    
INSERT INTO PRODUTO_BOLO (PRODUTO_NOME, BOLO_NOME, TIPO_QUANTIDADE, QUANTIDADE)
    VALUES ('PRODUTO BOLO 8', 'BOLO 8', 'KG', 1);
    
INSERT INTO PRODUTO_BOLO (PRODUTO_NOME, BOLO_NOME, TIPO_QUANTIDADE, QUANTIDADE)
    VALUES ('PRODUTO BOLO 9', 'BOLO 9', 'CG', 1);
    
INSERT INTO PRODUTO_BOLO (PRODUTO_NOME, BOLO_NOME, TIPO_QUANTIDADE, QUANTIDADE)
    VALUES ('PRODUTO BOLO 10', 'BOLO 10', 'G', 20);

/*--------------------------------------------PRODUTO_DOCE------------------------------------------------------*/
INSERT INTO PRODUTO_DOCE (PRODUTO_NOME, DOCE_NOME, TIPO_QUANTIDADE, QUANTIDADE)
    VALUES ('PRODUTO DOCE 1', 'DOCE 1', 'KG', 500);
    
INSERT INTO PRODUTO_DOCE (PRODUTO_NOME, DOCE_NOME, TIPO_QUANTIDADE, QUANTIDADE)
    VALUES ('PRODUTO DOCE 2', 'DOCE 2', 'MG', 1);
    
INSERT INTO PRODUTO_DOCE (PRODUTO_NOME, DOCE_NOME, TIPO_QUANTIDADE, QUANTIDADE)
    VALUES ('PRODUTO DOCE 3', 'DOCE 3', 'CG', 50);
    
INSERT INTO PRODUTO_DOCE (PRODUTO_NOME, DOCE_NOME, TIPO_QUANTIDADE, QUANTIDADE)
    VALUES ('PRODUTO DOCE 4', 'DOCE 4', 'DG', 24);
    
INSERT INTO PRODUTO_DOCE (PRODUTO_NOME, DOCE_NOME, TIPO_QUANTIDADE, QUANTIDADE)
    VALUES ('PRODUTO DOCE 5', 'DOCE 5', 'DAG', 28);
    
INSERT INTO PRODUTO_DOCE (PRODUTO_NOME, DOCE_NOME, TIPO_QUANTIDADE, QUANTIDADE)
    VALUES ('PRODUTO DOCE 6', 'DOCE 6', 'HECG', 100);
    
INSERT INTO PRODUTO_DOCE (PRODUTO_NOME, DOCE_NOME, TIPO_QUANTIDADE, QUANTIDADE)
    VALUES ('PRODUTO DOCE 7', 'DOCE 7', 'T', 8000);
    
INSERT INTO PRODUTO_DOCE (PRODUTO_NOME, DOCE_NOME, TIPO_QUANTIDADE, QUANTIDADE)
    VALUES ('PRODUTO DOCE 8', 'DOCE 8', 'KG', 1);
    
INSERT INTO PRODUTO_DOCE (PRODUTO_NOME, DOCE_NOME, TIPO_QUANTIDADE, QUANTIDADE)
    VALUES ('PRODUTO DOCE 9', 'DOCE 9', 'CG', 1);
    
INSERT INTO PRODUTO_DOCE (PRODUTO_NOME, DOCE_NOME, TIPO_QUANTIDADE, QUANTIDADE)
    VALUES ('PRODUTO DOCE 10', 'DOCE 10', 'G', 20);

/*--------------------------------------FORNECEDOR ALIMENTOS---------------------------------------*/
INSERT INTO FORNECEDOR_ALIMENTOS(CNPJ, NOME, EMAIL, ENDERECO, TELEFONE1, TELEFONE2)
    VALUES('72.780.846/0001-00', 'FORNECEDOR 1', 'FORNECEDOREMAIL1@GMAIL.COM', 'FORNECEDOR ENDERECO 1', 111111111111, 111111111112);
INSERT INTO FORNECEDOR_ALIMENTOS(CNPJ, NOME, EMAIL, ENDERECO, TELEFONE1, TELEFONE2)
    VALUES('72.780.846/0001-01', 'FORNECEDOR 2', 'FORNECEDOREMAIL2@GMAIL.COM', 'FORNECEDOR ENDERECO 2', 222222222222, NULL);
INSERT INTO FORNECEDOR_ALIMENTOS(CNPJ, NOME, EMAIL, ENDERECO, TELEFONE1, TELEFONE2)
    VALUES('72.780.846/0001-02', 'FORNECEDOR 3', 'FORNECEDOREMAIL3@GMAIL.COM', 'FORNECEDOR ENDERECO 3', 333333333333, 3333333333334);
INSERT INTO FORNECEDOR_ALIMENTOS(CNPJ, NOME, EMAIL, ENDERECO, TELEFONE1, TELEFONE2)
    VALUES('72.780.846/0001-03', 'FORNECEDOR 4', 'FORNECEDOREMAIL4@GMAIL.COM', 'FORNECEDOR ENDERECO 4', 444444444444, NULL);
INSERT INTO FORNECEDOR_ALIMENTOS(CNPJ, NOME, EMAIL, ENDERECO, TELEFONE1, TELEFONE2)
    VALUES('72.780.846/0001-04', 'FORNECEDOR 5', 'FORNECEDOREMAIL5@GMAIL.COM', 'FORNECEDOR ENDERECO 5', 555555555555, 5555555555556);
INSERT INTO FORNECEDOR_ALIMENTOS(CNPJ, NOME, EMAIL, ENDERECO, TELEFONE1, TELEFONE2)
    VALUES('72.780.846/0001-05', 'FORNECEDOR 6', 'FORNECEDOREMAIL6@GMAIL.COM', 'FORNECEDOR ENDERECO 6', 666666666666, NULL);
INSERT INTO FORNECEDOR_ALIMENTOS(CNPJ, NOME, EMAIL, ENDERECO, TELEFONE1, TELEFONE2)
    VALUES('72.780.846/0001-06', 'FORNECEDOR 7', 'FORNECEDOREMAIL7@GMAIL.COM', 'FORNECEDOR ENDERECO 7', 777777777777, 7777777777778);
INSERT INTO FORNECEDOR_ALIMENTOS(CNPJ, NOME, EMAIL, ENDERECO, TELEFONE1, TELEFONE2)
    VALUES('72.780.846/0001-07', 'FORNECEDOR 8', 'FORNECEDOREMAIL8@GMAIL.COM', 'FORNECEDOR ENDERECO 8', 888888888888, NULL);
INSERT INTO FORNECEDOR_ALIMENTOS(CNPJ, NOME, EMAIL, ENDERECO, TELEFONE1, TELEFONE2)
    VALUES('72.780.846/0001-08', 'FORNECEDOR 9', 'FORNECEDOREMAIL9@GMAIL.COM', 'FORNECEDOR ENDERECO 9', 999999999999, 999999999999910);
INSERT INTO FORNECEDOR_ALIMENTOS(CNPJ, NOME, EMAIL, ENDERECO, TELEFONE1, TELEFONE2)
    VALUES('72.780.846/0001-09', 'FORNECEDOR 10', 'FORNECEDOREMAIL10@GMAIL.COM', 'FORNECEDOR ENDERECO 10', 101010101010, NULL);

/*--------------------------------------------NOTA FISCAL------------------------------------------------------*/
INSERT INTO NOTA_FISCAL(NRO_FISCAL, DATA_EMISSAO) VALUES('1', TO_DATE('2018/11/07 10:20:00', 'YYYY/MM/DD HH24:MI:SS')); 
INSERT INTO NOTA_FISCAL(NRO_FISCAL, DATA_EMISSAO) VALUES('2', TO_DATE('2018/10/05 23:31:00', 'YYYY/MM/DD HH24:MI:SS')); 
INSERT INTO NOTA_FISCAL(NRO_FISCAL, DATA_EMISSAO) VALUES('3', TO_DATE('2018/12/04 20:34:00', 'YYYY/MM/DD HH24:MI:SS')); 
INSERT INTO NOTA_FISCAL(NRO_FISCAL, DATA_EMISSAO) VALUES('4', TO_DATE('2018/11/01 22:35:00', 'YYYY/MM/DD HH24:MI:SS')); 
INSERT INTO NOTA_FISCAL(NRO_FISCAL, DATA_EMISSAO) VALUES('5', TO_DATE('2018/09/05 21:30:00', 'YYYY/MM/DD HH24:MI:SS')); 
INSERT INTO NOTA_FISCAL(NRO_FISCAL, DATA_EMISSAO) VALUES('6', TO_DATE('2018/07/02 14:36:00', 'YYYY/MM/DD HH24:MI:SS')); 
INSERT INTO NOTA_FISCAL(NRO_FISCAL, DATA_EMISSAO) VALUES('7', TO_DATE('2018/06/11 15:38:00', 'YYYY/MM/DD HH24:MI:SS')); 
INSERT INTO NOTA_FISCAL(NRO_FISCAL, DATA_EMISSAO) VALUES('8', TO_DATE('2018/07/14 22:19:00', 'YYYY/MM/DD HH24:MI:SS')); 
INSERT INTO NOTA_FISCAL(NRO_FISCAL, DATA_EMISSAO) VALUES('9', TO_DATE('2018/06/26 22:19:00', 'YYYY/MM/DD HH24:MI:SS')); 
INSERT INTO NOTA_FISCAL(NRO_FISCAL, DATA_EMISSAO) VALUES('10', TO_DATE('2018/08/02 22:19:00', 'YYYY/MM/DD HH24:MI:SS')); 
    
/*------------------------------------ENCOMENDA------------------------------------------*/
INSERT INTO ENCOMENDA(FORNECEDOR_ALIMENTOS_CNPJ, PRODUTO_NOME, DATA_CONTRATO, PRECO_FORNECIMENTO, QUANTIDADE_PRODUTO, DATA_HORA_ENTREGA, LOCAL_ENTREGA, NOTA_FISCAL_NRO_FISCAL)
    VALUES('72.780.846/0001-00', 'PRODUTO 1', TO_DATE('2018/08/01 20:00:00', 'YYYY/MM/DD HH24:MI:SS'), 111, 11, TO_DATE('2018/09/01 20:00:00', 'YYYY/MM/DD HH24:MI:SS'), 'ENDERECO 1', '1');
--INSERT INTO ENCOMENDA(FORNECEDOR_ALIMENTOS_CNPJ, PRODUTO_NOME, DATA_CONTRATO, PRECO_FORNECIMENTO, QUANTIDADE_PRODUTO, DATA_HORA_ENTREGA, LOCAL_ENTREGA, NOTA_FISCAL_NRO_FISCAL)--TESTE DE TRIGGER_FESTA_ENCOMENDA, ENDERECO NAO EXISTENTE
--    VALUES('72.780.846/0001-00', 'PRODUTO ERRADO', TO_DATE('2018/08/01 20:00:00', 'YYYY/MM/DD HH24:MI:SS'), 111, 11, TO_DATE('2018/09/01 20:00:00', 'YYYY/MM/DD HH24:MI:SS'), 'ENDERECO ERRADO', '1');
--INSERT INTO ENCOMENDA(FORNECEDOR_ALIMENTOS_CNPJ, PRODUTO_NOME, DATA_CONTRATO, PRECO_FORNECIMENTO, QUANTIDADE_PRODUTO, DATA_HORA_ENTREGA, LOCAL_ENTREGA, NOTA_FISCAL_NRO_FISCAL)--TESTE DE TRIGGER_FESTA_ENCOMENDA, DATA SEM FESTA
--    VALUES('72.780.846/0001-00', 'PRODUTO ERRADO', TO_DATE('2018/08/01 20:00:00', 'YYYY/MM/DD HH24:MI:SS'), 111, 11, TO_DATE('2077/09/01 20:00:00', 'YYYY/MM/DD HH24:MI:SS'), 'ENDERECO 1', '1');
INSERT INTO ENCOMENDA(FORNECEDOR_ALIMENTOS_CNPJ, PRODUTO_NOME, DATA_CONTRATO, PRECO_FORNECIMENTO, QUANTIDADE_PRODUTO, DATA_HORA_ENTREGA, LOCAL_ENTREGA, NOTA_FISCAL_NRO_FISCAL)
    VALUES('72.780.846/0001-01', 'PRODUTO 2', TO_DATE('2018/08/02 20:00:00', 'YYYY/MM/DD HH24:MI:SS'), 222, 22, TO_DATE('2018/09/02 20:00:00', 'YYYY/MM/DD HH24:MI:SS'), 'ENDERECO 2', '2');
INSERT INTO ENCOMENDA(FORNECEDOR_ALIMENTOS_CNPJ, PRODUTO_NOME, DATA_CONTRATO, PRECO_FORNECIMENTO, QUANTIDADE_PRODUTO, DATA_HORA_ENTREGA, LOCAL_ENTREGA, NOTA_FISCAL_NRO_FISCAL)
    VALUES('72.780.846/0001-02', 'PRODUTO 3', TO_DATE('2018/08/03 20:00:00', 'YYYY/MM/DD HH24:MI:SS'), 333, 33, TO_DATE('2018/09/03 20:00:00', 'YYYY/MM/DD HH24:MI:SS'), 'ENDERECO 3', '3');
INSERT INTO ENCOMENDA(FORNECEDOR_ALIMENTOS_CNPJ, PRODUTO_NOME, DATA_CONTRATO, PRECO_FORNECIMENTO, QUANTIDADE_PRODUTO, DATA_HORA_ENTREGA, LOCAL_ENTREGA, NOTA_FISCAL_NRO_FISCAL)
    VALUES('72.780.846/0001-03', 'PRODUTO 4', TO_DATE('2018/08/04 20:00:00', 'YYYY/MM/DD HH24:MI:SS'), 444, 44, TO_DATE('2018/09/04 20:00:00', 'YYYY/MM/DD HH24:MI:SS'), 'ENDERECO 4', '4');
INSERT INTO ENCOMENDA(FORNECEDOR_ALIMENTOS_CNPJ, PRODUTO_NOME, DATA_CONTRATO, PRECO_FORNECIMENTO, QUANTIDADE_PRODUTO, DATA_HORA_ENTREGA, LOCAL_ENTREGA, NOTA_FISCAL_NRO_FISCAL)
    VALUES('72.780.846/0001-04', 'PRODUTO 5', TO_DATE('2018/08/05 20:00:00', 'YYYY/MM/DD HH24:MI:SS'), 555, 55, TO_DATE('2018/09/05 20:00:00', 'YYYY/MM/DD HH24:MI:SS'), 'ENDERECO 5', '5');
INSERT INTO ENCOMENDA(FORNECEDOR_ALIMENTOS_CNPJ, PRODUTO_NOME, DATA_CONTRATO, PRECO_FORNECIMENTO, QUANTIDADE_PRODUTO, DATA_HORA_ENTREGA, LOCAL_ENTREGA, NOTA_FISCAL_NRO_FISCAL)
    VALUES('72.780.846/0001-05', 'PRODUTO 6', TO_DATE('2018/08/06 20:00:00', 'YYYY/MM/DD HH24:MI:SS'), 666, 66, TO_DATE('2018/09/06 20:00:00', 'YYYY/MM/DD HH24:MI:SS'), 'ENDERECO 6', '6');
INSERT INTO ENCOMENDA(FORNECEDOR_ALIMENTOS_CNPJ, PRODUTO_NOME, DATA_CONTRATO, PRECO_FORNECIMENTO, QUANTIDADE_PRODUTO, DATA_HORA_ENTREGA, LOCAL_ENTREGA, NOTA_FISCAL_NRO_FISCAL)
    VALUES('72.780.846/0001-06', 'PRODUTO 7', TO_DATE('2018/08/07 20:00:00', 'YYYY/MM/DD HH24:MI:SS'), 777, 77, TO_DATE('2018/09/07 20:00:00', 'YYYY/MM/DD HH24:MI:SS'), 'ENDERECO 7', '7');
INSERT INTO ENCOMENDA(FORNECEDOR_ALIMENTOS_CNPJ, PRODUTO_NOME, DATA_CONTRATO, PRECO_FORNECIMENTO, QUANTIDADE_PRODUTO, DATA_HORA_ENTREGA, LOCAL_ENTREGA, NOTA_FISCAL_NRO_FISCAL)
    VALUES('72.780.846/0001-07', 'PRODUTO 8', TO_DATE('2018/08/08 20:00:00', 'YYYY/MM/DD HH24:MI:SS'), 888, 88, TO_DATE('2018/09/08 20:00:00', 'YYYY/MM/DD HH24:MI:SS'), 'ENDERECO 8', '8');   
INSERT INTO ENCOMENDA(FORNECEDOR_ALIMENTOS_CNPJ, PRODUTO_NOME, DATA_CONTRATO, PRECO_FORNECIMENTO, QUANTIDADE_PRODUTO, DATA_HORA_ENTREGA, LOCAL_ENTREGA, NOTA_FISCAL_NRO_FISCAL)
    VALUES('72.780.846/0001-08', 'PRODUTO 9', TO_DATE('2018/08/09 20:00:00', 'YYYY/MM/DD HH24:MI:SS'), 999, 99, TO_DATE('2018/09/09 20:00:00', 'YYYY/MM/DD HH24:MI:SS'), 'ENDERECO 9', '9');
INSERT INTO ENCOMENDA(FORNECEDOR_ALIMENTOS_CNPJ, PRODUTO_NOME, DATA_CONTRATO, PRECO_FORNECIMENTO, QUANTIDADE_PRODUTO, DATA_HORA_ENTREGA, LOCAL_ENTREGA, NOTA_FISCAL_NRO_FISCAL)
    VALUES('72.780.846/0001-09', 'PRODUTO 10', TO_DATE('2018/08/10 20:00:00', 'YYYY/MM/DD HH24:MI:SS'), 1110, 110, TO_DATE('2018/09/10 20:00:00', 'YYYY/MM/DD HH24:MI:SS'), 'ENDERECO 10', '10');
    
--A seguir, testaremos mais triggers dando deletes e updates tambem.    
    
-----------------DELETES-----------------------
--TESTE DE TRIGGER_PRECO_TOTAL_FESTA_FUNC
DELETE FROM FUNCIONARIO_FESTA WHERE FUNCIONARIO_CPF = '031.822.370-12';--TODOS OS PRECOS TOTAIS ATUALIZADOS COM SUCESSO
INSERT INTO FUNCIONARIO_FESTA(FUNCIONARIO_CPF, FESTA_NRO_REGISTRO, PRECO_FUNCIONARIO)
    VALUES('031.822.370-16', 4, 999.99);
DELETE FROM FUNCIONARIO_FESTA WHERE FUNCIONARIO_CPF = '031.822.370-16' AND FESTA_NRO_REGISTRO = 9;--REMOVENDO FUNCIONARIO SOMENTE DE UMA FESTA ESPECIFICA, PRECO TOTAL ATUALIZADO CORRETAMENTE

-----------------UPDATES---------------------------
--TESTE DE TRIGGER_PRECO_TOTAL_FESTA_FUNC
UPDATE FUNCIONARIO_FESTA SET PRECO_FUNCIONARIO = 1000 
    WHERE FUNCIONARIO_CPF = '031.822.370-16' AND FESTA_NRO_REGISTRO = 5;--PRECO ATUALIZADO COM SUCESSO

COMMIT;
---------------SELECTS - CONSULTAS DE MEDIO-ALTO NIVEIS --------------------

--Verificar, para cada festa que tiver bebidas alcoolicas, a quantidade de bebidas alcoolicas diferentes em cada festa. 
--A mesma coisa poderia ser feita para calcular a quantidade de comidas diferentes 
--em cada festa trocando o valor de A.TIPO_ALIMENTO para 'COMIDA' e retirando a segunda condicao do WHERE.
SELECT F.NRO_REGISTRO, COUNT(*) AS QTDE_BEB_ALCOOLICAS_DIF FROM FESTA F 
    JOIN ALIMENTO_FESTA AF ON AF.FESTA_NRO_REGISTRO = F.NRO_REGISTRO 
    JOIN ALIMENTO A ON A.NOME = AF.ALIMENTO_NOME 
    WHERE A.TIPO_ALIMENTO = 'BEBIDA' AND A.TIPO_COMIDA_BEBIDA = 'ALCOOLICA' 
    GROUP BY F.NRO_REGISTRO;

--Selecionar todas as festas de 2018 e, para as festas que tiverem alimentos, mostrar os nomes dos alimentos que foram pedidos para cada festa 
--e suas respectivas quantidades.
SELECT F.NRO_REGISTRO, A.NOME AS NOME_ALIMENTO, AF.QUANTIDADE FROM FESTA F 
    LEFT JOIN ALIMENTO_FESTA AF ON F.NRO_REGISTRO = AF.FESTA_NRO_REGISTRO
    LEFT JOIN ALIMENTO A ON A.NOME = AF.ALIMENTO_NOME 
    WHERE EXTRACT(YEAR FROM F.DATA_HORA) = '2018'
    ORDER BY F.NRO_REGISTRO;

--Para uma determinada festa, descobrir o preco da festa SOMENTE em relacao aos precos dos alimentos presentes nesta,
--descontando precos de funcionarios, bolos e doces, se houver. O GROUP-BY eh necessario pois se nao o SELECT nao eh compilado
--(isto se deve por causa do SUM(AF.QUANTIDADE * A.PRECO_PESSOA utilizado!).
SELECT F.NRO_REGISTRO, SUM(AF.QUANTIDADE * A.PRECO_PESSOA) AS PRECO_ALIMENTOS_FESTA FROM FESTA F
    JOIN ALIMENTO_FESTA AF ON AF.FESTA_NRO_REGISTRO = F.NRO_REGISTRO 
    JOIN ALIMENTO A ON A.NOME = AF.ALIMENTO_NOME 
    WHERE F.NRO_REGISTRO = '1' 
    GROUP BY F.NRO_REGISTRO;
    
--Para verificar corretude do comando acima pode-se executar a seguinte consulta e calcular o preco matematicamente numa folha de papel a parte.
SELECT A.NOME, A.PRECO_PESSOA, AF.QUANTIDADE FROM FESTA F 
    JOIN ALIMENTO_FESTA AF ON AF.FESTA_NRO_REGISTRO = F.NRO_REGISTRO 
    JOIN ALIMENTO A ON A.NOME = AF.ALIMENTO_NOME 
    WHERE F.NRO_REGISTRO = '1';
    
--Para cada festa, selecionar o nome e a quantidade dos talheres pedidos, alem da quantidade presente de cada um destes no estoque da empresa.
--Ordene o resultado em ordem alfabetica em relacao aos nome dos talheres.
SELECT F.NRO_REGISTRO, U.NOME, UF.QUANTIDADE, U.QTD_ESTOQUE FROM FESTA F 
    JOIN UTENSILIO_FESTA UF ON F.NRO_REGISTRO = UF.FESTA_NRO_REGISTRO
    JOIN UTENSILIO U ON UF.UTENSILIO_NOME = U.NOME 
    WHERE U.TIPO = 'TALHER' ORDER BY U.NOME;
    
--Para todas as festas de casamento com pedidos de dois ou mais bolos, mostrar seu numero de registro
--e mostrar a soma total dos precos de todos os bolos destas festas.
SELECT F.NRO_REGISTRO, COUNT(*) AS QTDE_BOLOS_PEDIDOS, SUM(B.PRECO) AS SOMA_PRECO_BOLOS FROM FESTA F
    JOIN BOLO_FESTA BF ON F.NRO_REGISTRO = BF.FESTA_NRO_REGISTRO
    JOIN BOLO B ON BF.BOLO_NOME = B.NOME 
    GROUP BY F.NRO_REGISTRO HAVING COUNT(*) > 1 
    ORDER BY F.NRO_REGISTRO; 

--Para cada alimento pedido em todas as festas armazenadas, mostrar os nomes dos produtos necessarios para confecciona-loS,
--alem de cada quantidade de produto e seu tipo de quantidade.
SELECT F.NRO_REGISTRO, A.NOME, PA.PRODUTO_NOME, PA.QUANTIDADE, PA.TIPO_QUANTIDADE FROM FESTA F 
    JOIN ALIMENTO_FESTA AF ON AF.FESTA_NRO_REGISTRO = F.NRO_REGISTRO 
    JOIN ALIMENTO A ON A.NOME = AF.ALIMENTO_NOME 
    JOIN PRODUTO_ALIMENTO PA ON PA.ALIMENTO_NOME = A.NOME
    ORDER BY F.NRO_REGISTRO, A.NOME;

--Selecionar quanto ainda tem no estoque de um produto, excluindo-se os produtos ja reservados
SELECT U.QTD_ESTOQUE FROM UTENSILIO U 
    WHERE U.NOME = 'COLHER 1';

--descobrir quais encomendas foram realizadas para um local especifico em determinada data 
SELECT E.PRODUTO_NOME FROM ENCOMENDA E
    WHERE E.DATA_HORA_ENTREGA = TO_DATE('2018/09/01 20:00:00', 'YYYY/MM/DD HH24:MI:SS') AND E.LOCAL_ENTREGA = 'ENDERECO 1';
