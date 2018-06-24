/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package model;

/*CREATE TABLE ALIMENTO (
    NOME VARCHAR2(40) NOT NULL,
    PRECO_PESSOA NUMBER(12,2) DEFAULT 0 NOT NULL,
    DESCRICAO VARCHAR2(256),
    TIPO_ALIMENTO CHAR(6) NOT NULL,
    PRONTO NUMBER(1) DEFAULT 0 NOT NULL,
    TIPO_COMIDA_BEBIDA CHAR(15) NOT NULL,
    CONSTRAINT PK_ALIMENTO PRIMARY KEY(NOME),
    CONSTRAINT CK_ALIMENTO_TIPO_ALIMENTO CHECK((TIPO_ALIMENTO IN ('COMIDA')
                AND TIPO_COMIDA_BEBIDA IN ('ENTRADA', 'GUARNICAO', 'SALGADO', 'APERITIVO', 'MOLHO', 'SOBREMESA', 'PRATO PRINCIPAL'))
                OR (TIPO_ALIMENTO IN ('BEBIDA')
                AND TIPO_COMIDA_BEBIDA IN ('NAO ALCOOLICA', 'ALCOOLICA'))),
    CONSTRAINT CK1_ALIMENTO CHECK(PRECO_PESSOA >= 0),
    CONSTRAINT CK2_ALIMENTO CHECK(PRONTO IN (0, 1))
); */

public class Alimento {
    private String nome;
    private double precoPessoa;
    private String descricao;
    private String tipoAlimento;
    private boolean pronto;
    private String tipoComidaBebida;

    public Alimento(String nome, double precoPessoa, String descricao, String tipoAlimento, int pronto, String tipoComidaBebida) {
        this.nome = nome;
        this.precoPessoa = precoPessoa;
        this.descricao = descricao;
        this.tipoAlimento = tipoAlimento;
        this.pronto = pronto != 0;
        this.tipoComidaBebida = tipoComidaBebida;
    }

    @Override
    public String toString() {
        return "Alimento{" + "nome=" + nome + ", precoPessoa=" + precoPessoa + ", descricao=" + descricao + ", tipoAlimento=" + tipoAlimento + ", pronto=" + pronto + ", tipoComidaBebida=" + tipoComidaBebida + '}';
    }

    public String getNome() {
        return nome;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    public double getPrecoPessoa() {
        return precoPessoa;
    }

    public void setPrecoPessoa(double precoPessoa) {
        this.precoPessoa = precoPessoa;
    }

    public String getDescricao() {
        return descricao;
    }

    public void setDescricao(String descricao) {
        this.descricao = descricao;
    }

    public String getTipoAlimento() {
        return tipoAlimento;
    }

    public void setTipoAlimento(String tipoAlimento) {
        this.tipoAlimento = tipoAlimento;
    }

    public boolean isPronto() {
        return pronto;
    }

    public void setPronto(int pronto) {
        this.pronto = pronto != 0;
    }

    public String getTipoComidaBebida() {
        return tipoComidaBebida;
    }

    public void setTipoComidaBebida(String tipoComidaBebida) {
        this.tipoComidaBebida = tipoComidaBebida;
    }
}
