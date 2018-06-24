 /*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package model;

/*CREATE TABLE FUNCIONARIO (
    CPF CHAR(14) NOT NULL,
    NOME VARCHAR2(40) NOT NULL,
    EMAIL VARCHAR2(60),
    TELEFONE1 NUMBER(20) NOT NULL,
    TELEFONE2 NUMBER(20),
    FUNCAO CHAR(32) NOT NULL,
    FUNCIONARIO_GERENTE_CPF CHAR(14),
    CONSTRAINT PK_FUNCIONARIO PRIMARY KEY(CPF),
    CONSTRAINT FK_FUNCIONARIO_FUNCIONARIO FOREIGN KEY(FUNCIONARIO_GERENTE_CPF)
                REFERENCES FUNCIONARIO(CPF)
                ON DELETE SET NULL,
    CONSTRAINT CK1_FUNCIONARIO CHECK(REGEXP_LIKE(CPF, '[0-9]{3}\.[0-9]{3}\.[0-9]{3}\-[0-9]{2}')),
    CONSTRAINT CK2_FUNCIONARIO CHECK(EMAIL IS NULL OR EMAIL LIKE '_%@_%._%'),
    CONSTRAINT CK3_FUNCIONARIO CHECK(TELEFONE1 >= 0),
    CONSTRAINT CK4_FUNCIONARIO CHECK(TELEFONE2 IS NULL OR TELEFONE2 >= 0)
);*/



public class Funcionario {
    private String cpf;
    private String nome;
    private String email;
    private int telefone1;
    private int telefone2;
    private String funcao;
    private String funcionarioGerenteCpf;

    
    public Funcionario(String cpf, String nome, String email, int telefone1, int telefone2, String funcao, String funcionarioGerenteCpf) {
        this.cpf = cpf;
        this.nome = nome;
        this.email = email;
        this.telefone1 = telefone1;
        this.telefone2 = telefone2;
        this.funcao = funcao;
        this.funcionarioGerenteCpf = funcionarioGerenteCpf;
    }

    @Override
    public String toString() {
        return "Funcionario{" + "cpf=" + cpf + ", nome=" + nome + ", email=" + email + ", telefone1=" + telefone1 + ", telefone2=" + telefone2 + ", funcao=" + funcao + ", funcionarioGerenteCpf=" + funcionarioGerenteCpf + '}';
    }

    public String getCpf() {
        return cpf;
    }

    public void setCpf(String cpf) {
        this.cpf = cpf;
    }

    public String getNome() {
        return nome;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }


    public int getTelefone1() {
        return telefone1;
    }

    public void setTelefone1(int telefone1) {
        this.telefone1 = telefone1;
    }

    public int getTelefone2() {
        return telefone2;
    }

    public void setTelefone2(int telefone2) {
        this.telefone2 = telefone2;
    }

    public String getFuncao() {
        return funcao;
    }

    public void setFuncao(String funcao) {
        this.funcao = funcao;
    }

    public String getFuncionarioGerenteCpf() {
        return funcionarioGerenteCpf;
    }

    public void setFuncionarioGerenteCpf(String funcionarioGerenteCpf) {
        this.funcionarioGerenteCpf = funcionarioGerenteCpf;
    }
    
    
}
