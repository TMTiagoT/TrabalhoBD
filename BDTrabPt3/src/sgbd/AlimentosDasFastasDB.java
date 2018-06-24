/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package sgbd;

//resgatar quais alimentos estão contidos no menu de cada festa

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
<<<<<<< HEAD
import model.AlimentosDasFestas;
=======
import model.selectAux.AlimentosDasFestas;
>>>>>>> master


/*SELECT ALIMENTO_FESTA.FESTA_NRO_REGISTRO, ALIMENTO.NOME, ALIMENTO.DESCRICAO, ALIMENTO.TIPO_ALIMENTO, ALIMENTO.TIPO_COMIDA_BEBIDA
    FROM ALIMENTO JOIN ALIMENTO_FESTA ON ALIMENTO.NOME = ALIMENTO_FESTA.ALIMENTO_NOME
    ORDER BY ALIMENTO_FESTA.FESTA_NRO_REGISTRO;*/

<<<<<<< HEAD
/**
 *
 * @author andre
 */
=======
>>>>>>> master
public class AlimentosDasFastasDB {
    
    /**
     *
     * @return
     */
    public ArrayList<AlimentosDasFestas> AlimentosNosMenus_SelectAll() {
        ArrayList<AlimentosDasFestas> alimentosNosMenus = new ArrayList();
        
        Connection con = null;
        try {
            con = ConnectionSGBD.getConnection();
            Statement st = con.createStatement();
<<<<<<< HEAD
            ResultSet rs = st.executeQuery("SELECT ALIMENTO_FESTA.FESTA_NRO_REGISTRO, PRODUTO_ALIMENTO.PRODUTO_NOME, ALIMENTO.NOME, ALIMENTO.DESCRICAO, ALIMENTO.TIPO_ALIMENTO, ALIMENTO.TIPO_COMIDA_BEBIDA" +
"    FROM ALIMENTO JOIN ALIMENTO_FESTA ON ALIMENTO.NOME = ALIMENTO_FESTA.ALIMENTO_NOME JOIN PRODUTO_ALIMENTO ON PRODUTO_ALIMENTO.ALIMENTO_NOME = ALIMENTO.NOME" +
"    ORDER BY ALIMENTO_FESTA.FESTA_NRO_REGISTRO");
=======
            ResultSet rs = st.executeQuery("SELECT ALIMENTO_FESTA.FESTA_NRO_REGISTRO, PRODUTO_ALIMENTO.PRODUTO_NOME, ALIMENTO.NOME, ALIMENTO.DESCRICAO, ALIMENTO.TIPO_ALIMENTO, ALIMENTO.TIPO_COMIDA_BEBIDA\n" +
"    FROM ALIMENTO JOIN ALIMENTO_FESTA ON ALIMENTO.NOME = ALIMENTO_FESTA.ALIMENTO_NOME JOIN PRODUTO_ALIMENTO ON PRODUTO_ALIMENTO.ALIMENTO_NOME = ALIMENTO.NOME\n" +
"    ORDER BY ALIMENTO_FESTA.FESTA_NRO_REGISTRO;");
>>>>>>> master

            while (rs.next()) {
                alimentosNosMenus.add(new AlimentosDasFestas(rs.getInt(1), rs.getString(2), rs.getString(3), rs.getString(4), rs.getString(5), rs.getString(6)));
            }
            
            //con.commit(); //depois ver de desabilitar commit automatico, mas por enquanto eh melhor assim
        } catch (SQLException e) {
            System.out.println(e.getMessage());
            System.out.println("Erro no Utensilio_SelectAll");
        } catch (Exception e) {
            System.out.println(e.getMessage());
            System.out.println("Erro no Utensilio_SelectAll");
        }
        
        ConnectionSGBD.CloseConnection(con);

        return alimentosNosMenus;
    }

    private void print(String string) {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }
    
}
