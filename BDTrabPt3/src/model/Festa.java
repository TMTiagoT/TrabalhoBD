/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package model;

/*CREATE TABLE FESTA (
    NRO_REGISTRO NUMBER(12) NOT NULL, --GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1) NOT NULL, --AUTO_INCREMENT ("NAO PODE SER ESCRITO"),
    NRO_CONVIDADOS NUMBER(12),
    ENDERECO VARCHAR2(240) NOT NULL,
    PRECO_FESTA NUMBER(12,2) DEFAULT 0 NOT NULL,
    TIPO CHAR(9) NOT NULL,
    DATA_HORA DATE NOT NULL,
    PRECO_TOTAL NUMBER(12,2) DEFAULT 0, --ATRIBUTO DERIVADO
    CLIENTE_CPF CHAR(14),
    CONSTRAINT PK_FESTA PRIMARY KEY(NRO_REGISTRO),
    CONSTRAINT FK_FESTA_CLIENTE FOREIGN KEY(CLIENTE_CPF)
            REFERENCES CLIENTE(CPF)
            ON DELETE SET NULL,
    CONSTRAINT CK1_FESTA CHECK(TIPO IN ('CASAMENTO', 'FORMATURA')),
    CONSTRAINT CK2_FESTA CHECK(NRO_CONVIDADOS IS NULL OR NRO_CONVIDADOS >= 0),
    CONSTRAINT CK3_FESTA CHECK(PRECO_FESTA >= 0)
); */


<<<<<<< HEAD
/**
 *
 * @author andre
 */
=======
>>>>>>> master
public class Festa {
    private int nroRegistro;
    private int nroConvidados;
    private String endereco;
    private double precoFesta;
    private String tipo;
    private String dataHora;
    private double precoTotal;
    private String clienteCpf;

    public Festa(int nroRegistro, int nroConvidados, String endereco, double precoFesta, String tipo, String dataHora, double precoTotal, String clienteCpf) {
        this.nroRegistro = nroRegistro;
        this.nroConvidados = nroConvidados;
        this.endereco = endereco;
        this.precoFesta = precoFesta;
        this.tipo = tipo;
        this.dataHora = dataHora;
        this.precoTotal = precoTotal;
        this.clienteCpf = clienteCpf;
    }

    @Override
    public String toString() {
        return "Festa{" + "nroRegistro=" + nroRegistro + ", nroConvidados=" + nroConvidados + ", endereco=" + endereco + ", precoFesta=" + precoFesta + ", tipo=" + tipo + ", dataHora=" + dataHora + ", precoTotal=" + precoTotal + ", cpf=" + clienteCpf + '}';
    }

    public int getNroRegistro() {
        return nroRegistro;
    }

    public void setNroRegistro(int nroRegistro) {
        this.nroRegistro = nroRegistro;
    }

    public int getNroConvidados() {
        return nroConvidados;
    }

    public void setNroConvidados(int nroConvidados) {
        this.nroConvidados = nroConvidados;
    }

    public String getEndereco() {
        return endereco;
    }

    public void setEndereco(String endereco) {
        this.endereco = endereco;
    }

    public double getPrecoFesta() {
        return precoFesta;
    }

    public void setPrecoFesta(double precoFesta) {
        this.precoFesta = precoFesta;
    }

    public String getTipo() {
        return tipo;
    }

    public void setTipo(String tipo) {
        this.tipo = tipo;
    }

    public String getDataHora() {
        return dataHora;
    }

    public void setDataHora(String dataHora) {
        this.dataHora = dataHora;
    }

    public double getPrecoTotal() {
        return precoTotal;
    }

    public void setPrecoTotal(double precoTotal) {
        this.precoTotal = precoTotal;
    }

    public String getClienteCpf() {
        return clienteCpf;
    }

    public void setClienteCpf(String clienteCpf) {
        this.clienteCpf = clienteCpf;
    }
    
    
}
