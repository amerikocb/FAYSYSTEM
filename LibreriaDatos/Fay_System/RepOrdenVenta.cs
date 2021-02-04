using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace LibreriaDatos.Fay_System
{
    public class RepOrdenVenta:Repositorio<OrdenVenta>
    {
        public RepOrdenVenta(FayceEntities contexto) : base(contexto)
        {

        }
        public DataTable ObtenerListaOrdenesVenta()
        {
            DataTable dt = new DataTable();
            SqlConnection cone = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["cone"].ConnectionString);
            cone.Open();
            string query = "SELECT C.Id, C.TipoOrdenVenta, C.CostoTotal, C.Fecha, U.Nombre AS Usuario, ES.Descripcion AS EstadoOrdenVenta, IdCliente, PC.ApellidoPaterno + ' ' + Pc.ApellidoMaterno + ', ' +pc.Nombres AS NombreRazonSocial " +
                            "FROM OrdenVenta C" +
                            "	 LEFT JOIN Cliente CL ON CL.IdCliente = C.IdClienteNatural " +
                            "	 INNER JOIN Persona PC ON PC.Id = CL.IdPersona " +
                            "	 INNER JOIN Usuario U ON C.IdUsuario = U.id " +
                            "    INNER JOIN Empleado E ON E.Id = U.IdEmpleado " +
                            "    INNER JOIN Persona PE ON PE.Id = E.IdPersona " +
                            "	 INNER JOIN Estado ES ON ES.Id = C.IdEstado " +
                            "UNION ALL " +
                            "SELECT C.Id, C.TipoOrdenVenta, C.CostoTotal, C.Fecha, U.Nombre, ES.Descripcion, IdClienteJuridico, PE.RazonSocial " +
                            "FROM OrdenVenta C " +
                            "	 LEFT JOIN Empresa E ON C.IdClienteJuridico = E.Id " +
                            "	 INNER JOIN Persona PE ON PE.ID = E.IdPersona " +
                            "	 INNER JOIN Usuario U ON C.IdUsuario = U.id " +
                            "    INNER JOIN Empleado EM ON EM.Id = U.IdEmpleado " +
                            "    INNER JOIN Persona PEM ON PEM.Id = EM.IdPersona " +
                            "	 INNER JOIN Estado ES ON ES.Id = C.IdEstado " +
                            "ORDER BY 1 DESC ";

            SqlCommand cmd = new SqlCommand(query, cone);
            dt.Load(cmd.ExecuteReader());
            cone.Close();
            return dt;
        }
        public int? ObtenerEstadoOrdenVenta(int IdOrdenVenta)
        {
            return _contexto.OrdenVenta.Where(ov => ov.Id == IdOrdenVenta).FirstOrDefault<OrdenVenta>().IdEstado;
        }

        public string ConvertirOrdenVenta_OrdenTrabajo(int IdOrdenVenta, int IdUsuario)
        {
            string retorno = "";
            SqlConnection cone = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["cone"].ConnectionString);
            cone.Open();
            string query = "EXEC [dbo].[St_P_ConvertirOV_OrdenT] " + IdOrdenVenta + ", " + IdUsuario;

            SqlCommand cmd = new SqlCommand(query, cone);
            try
            {
                if (cmd.ExecuteNonQuery() > 0)
                    retorno = "";
            }
            catch (Exception ex)
            {
                retorno = ex.Message;
            }
            return retorno;
        }
    }
}
