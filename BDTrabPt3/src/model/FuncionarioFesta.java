/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package model;

/*CREATE TABLE FUNCIONARIO_FESTA (
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
);*/


<<<<<<< HEAD
/**
 *
 * @author andre
 */
=======
>>>>>>> master
public class FuncionarioFesta {
    private String funcionarioCpf;
    private int festaNroRegistro;
    private double precoFuncionario;

    public FuncionarioFesta(String funcionarioCpf, int festaNroRegistro, double precoFuncionario) {
        this.funcionarioCpf = funcionarioCpf;
        this.festaNroRegistro = festaNroRegistro;
        this.precoFuncionario = precoFuncionario;
    }

    @Override
    public String toString() {
        return "FuincionarioFesta{" + "funcionarioCpf=" + funcionarioCpf + ", festaNroRegistro=" + festaNroRegistro + ", precoFuncionario=" + precoFuncionario + '}';
    }

    public String getFuncionarioCpf() {
        return funcionarioCpf;
    }

    public void setFuncionarioCpf(String funcionarioCpf) {
        this.funcionarioCpf = funcionarioCpf;
    }

    public int getFestaNroRegistro() {
        return festaNroRegistro;
    }

    public void setFestaNroRegistro(int festaNroRegistro) {
        this.festaNroRegistro = festaNroRegistro;
    }

    public double getPrecoFuncionario() {
        return precoFuncionario;
    }

    public void setPrecoFuncionario(double precoFuncionario) {
        this.precoFuncionario = precoFuncionario;
    }
    
    
}
