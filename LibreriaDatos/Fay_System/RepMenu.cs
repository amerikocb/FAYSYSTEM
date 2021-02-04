using LibreriaDatos.Fay_System.DTO;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace LibreriaDatos.Fay_System
{
    public class RepMenu : Repositorio<Menu>
    {
        public RepMenu(FayceEntities contexto) : base(contexto)
        {
        }

        public List<DTOMenu> Obtener_x_usuario(string usuario)
        {
            return _contexto.Menu.Where(m => m.Habilitado == true)
                .Select(m => new DTOMenu
                {
                    IdMenu = m.IdMenu,
                    NombreMenu = m.NombreMenu,
                    IdMenuPadre = m.IdMenuPadre,
                    Posicion = m.Posicion,
                    Icono = m.Icono,
                    Url = m.Url
                })
                .ToList();
        }


        public List<DTOMenu> Obtener_x_usuario(int usuario = 0)
        {
            return _contexto.Database.SqlQuery<DTOMenu>(@"RetornarMenu @IdUsuario", new System.Data.SqlClient.SqlParameter("@IdUsuario", usuario)).ToList();
        }
        public DataTable ObtenerMenuPorUsuario(int IdUsuario)
        { 
            DataTable dt = new DataTable();
            SqlConnection cone = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["cone"].ConnectionString);
            cone.Open();
            //string query = "EXEC RetornarMenu " + Idusuario ;
            SqlCommand cmd = new SqlCommand("RetornarMenu", cone);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add("@IdUsuario", SqlDbType.Int).Value = IdUsuario;
            try
            {
                dt.Load(cmd.ExecuteReader());
                cone.Close();
            }
            catch(Exception ex)
            {
                throw ex;
            }

            return dt;
        }

    }
}
