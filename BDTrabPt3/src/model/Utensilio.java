/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package model;


/*CREATE TABLE UTENSILIO (
    NOME VARCHAR2(40) NOT NULL,
    QTD_ESTOQUE NUMBER(12) DEFAULT 0 NOT NULL,
    TIPO CHAR(32) NOT NULL,
    CONSTRAINT PK_UTENSILIO PRIMARY KEY(NOME),
    CONSTRAINT CK1_UTENSILIO CHECK(QTD_ESTOQUE >= 0)
); */


<<<<<<< HEAD
/**
 *
 * @author andre
 */
=======
>>>>>>> master
public class Utensilio {
    private String nome;
    private int qtdEstoque;
    private String tipo;

    public Utensilio(String nome, int qtdEstoque, String tipo) {
        this.nome = nome;
        this.qtdEstoque = qtdEstoque;
        this.tipo = tipo;
    }

    @Override
    public String toString() {
        return "Utens\u00edlio{" + "nome=" + nome + ", qtdEstoque=" + qtdEstoque + ", tipo=" + tipo + '}';
    }

    public String getNome() {
        return nome;
    }

    public int getQtdEstoque() {
        return qtdEstoque;
    }

    public String getTipo() {
        return tipo;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    public void setQtdEstoque(int qtdEstoque) {
        this.qtdEstoque = qtdEstoque;
    }

    public void setTipo(String tipo) {
        this.tipo = tipo;
    }
    
    
}
