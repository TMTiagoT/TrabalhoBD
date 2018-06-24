/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package model;

/*CREATE TABLE UTENSILIO_FESTA (
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
);*/


<<<<<<< HEAD
/**
 *
 * @author andre
 */
=======
>>>>>>> master
public class UtensilioFesta {
    private int festaNroRegistro;
    private String utensilioNome;
    private int quantidade;

    public UtensilioFesta(int festaNroRegistro, String utensilioNome, int quantidade) {
        this.festaNroRegistro = festaNroRegistro;
        this.utensilioNome = utensilioNome;
        this.quantidade = quantidade;
    }
    
    @Override
    public String toString() {
        return "UtensilioFesta{" + "festaNroRehistro=" + festaNroRegistro + ", utensilioNome=" + utensilioNome + ", quantidade=" + quantidade + '}';
    }

    public int getFestaNroRegistro() {
        return festaNroRegistro;
    }

    public void setFestaNroRegistro(int festaNroRegistro) {
        this.festaNroRegistro = festaNroRegistro;
    }

    public String getUtensilioNome() {
        return utensilioNome;
    }

    public void setUtensilioNome(String utensilioNome) {
        this.utensilioNome = utensilioNome;
    }

    public int getQuantidade() {
        return quantidade;
    }

    public void setQuantidade(int quantidade) {
        this.quantidade = quantidade;
    }
    
    
}
