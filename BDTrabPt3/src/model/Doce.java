/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package model;

/*CREATE TABLE DOCE (
    NOME VARCHAR2(40) NOT NULL,
    MODELO VARCHAR2(40),
    PRECO_UNIDADE NUMBER(12,2) DEFAULT 0 NOT NULL,
    DESCRICAO CHAR(256),
    CONSTRAINT PK_DOCE PRIMARY KEY(NOME),
    CONSTRAINT CK1_DOCE CHECK(PRECO_UNIDADE >= 0)
);*/

<<<<<<< HEAD

/**
 *
 * @author andre
 */
=======
>>>>>>> master
public class Doce {
    private String nome;
    private String modelo;
    private double precoUnidade;
    private String descricao;

    public Doce(String nome, String modelo, double precoUnidade, String descricao) {
        this.nome = nome;
        this.modelo = modelo;
        this.precoUnidade = precoUnidade;
        this.descricao = descricao;
    }

    @Override
    public String toString() {
        return "Doce{" + "nome=" + nome + ", modelo=" + modelo + ", precoUnidade=" + precoUnidade + ", descricao=" + descricao + '}';
    }

    public String getNome() {
        return nome;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    public String getModelo() {
        return modelo;
    }

    public void setModelo(String modelo) {
        this.modelo = modelo;
    }

    public double getPrecoUnidade() {
        return precoUnidade;
    }

    public void setPrecoUnidade(double precoUnidade) {
        this.precoUnidade = precoUnidade;
    }

    public String getDescricao() {
        return descricao;
    }

    public void setDescricao(String descricao) {
        this.descricao = descricao;
    }
    
    
}
