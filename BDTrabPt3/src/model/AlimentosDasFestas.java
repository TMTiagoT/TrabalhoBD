/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package model;

//associar cada alimento presente na festa com seus respectivos produtos

/*SELECT ALIMENTO_FESTA.FESTA_NRO_REGISTRO, PRODUTO_ALIMENTO.PRODUTO_NOME, ALIMENTO.NOME, ALIMENTO.DESCRICAO, ALIMENTO.TIPO_ALIMENTO, ALIMENTO.TIPO_COMIDA_BEBIDA
    FROM ALIMENTO JOIN ALIMENTO_FESTA ON ALIMENTO.NOME = ALIMENTO_FESTA.ALIMENTO_NOME JOIN PRODUTO_ALIMENTO ON PRODUTO_ALIMENTO.ALIMENTO_NOME = ALIMENTO.NOME
    ORDER BY ALIMENTO_FESTA.FESTA_NRO_REGISTRO; */

public class AlimentosDasFestas {
    private int festaNroRegistro;
    private String produto;
    private String nome;
    private String descricao;
    private String tipoAlimento;
    private String tipoComidaBebida;

    public AlimentosDasFestas(int festaNroRegistro, String nome, String descricao, String tipoAlimento, String tipoComidaBebida) {
        this.festaNroRegistro = festaNroRegistro;
        this.nome = nome;
        this.descricao = descricao;
        this.tipoAlimento = tipoAlimento;
        this.tipoComidaBebida = tipoComidaBebida;
    }

    public AlimentosDasFestas(int festaNroRegistro, String produto, String nome, String descricao, String tipoAlimento, String tipoComidaBebida) {
        this.festaNroRegistro = festaNroRegistro;
        this.produto = produto;
        this.nome = nome;
        this.descricao = descricao;
        this.tipoAlimento = tipoAlimento;
        this.tipoComidaBebida = tipoComidaBebida;
    }

    @Override
    public String toString() {
        return "AlimentosNosMenus{" + "festaNroRegistro=" + festaNroRegistro + ", produto=" + produto + ", nome=" + nome + ", descricao=" + descricao + ", tipoAlimento=" + tipoAlimento + ", tipoComidaBebida=" + tipoComidaBebida + '}';
    }

    public int getFestaNroRegistro() {
        return festaNroRegistro;
    }

    public void setFestaNroRegistro(int festaNroRegistro) {
        this.festaNroRegistro = festaNroRegistro;
    }

    public String getProduto() {
        return produto;
    }

    public void setProduto(String produto) {
        this.produto = produto;
    }

    public String getNome() {
        return nome;
    }

    public void setNome(String nome) {
        this.nome = nome;
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

    public String getTipoComidaBebida() {
        return tipoComidaBebida;
    }

    public void setTipoComidaBebida(String tipoComidaBebida) {
        this.tipoComidaBebida = tipoComidaBebida;
    }

    
}
