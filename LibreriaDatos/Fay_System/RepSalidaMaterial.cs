using System;
using System.Data;
using System.Data.SqlClient;
using System.Linq;

namespace LibreriaDatos.Fay_System
{
    public class RepSalidaMaterial : Repositorio<SalidaMaterial>
    {
        public RepSalidaMaterial(FayceEntities contexto) : base(contexto)
        {
        }
        public DataTable ObtenerListaSalidaMateriales_Empleado()
        {
            DataTable dt = new DataTable();
            SqlConnection cone = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["cone"].ConnectionString);
            cone.Open();
            string query = "SELECT SM.Id, SM.Fecha, U.Nombre AS Usuario, ES.Descripcion AS EstadoSalidaMaterial, EM.Id, PE.ApellidoPaterno + ' ' + PE.ApellidoMaterno + ', ' + PE.Nombres AS NombreRazonSocial " +
                            "FROM SalidaMaterial SM" +
                            "	 INNER JOIN Usuario U ON SM.IdUsuario = U.id " +
                            "	 INNER JOIN Empleado EM ON EM.Id = SM.IdEmpleado " +
                            "	 INNER JOIN Persona PE ON PE.Id = EM.IdPersona " +
                            "	 INNER JOIN Estado ES ON ES.Id = SM.IdEstado ";

            SqlCommand cmd = new SqlCommand(query, cone);
            dt.Load(cmd.ExecuteReader());
            cone.Close();
            return dt;
        }

        public DataTable ObtenerListaSalidaMateriales()
        {
            DataTable dt = new DataTable();
            SqlConnection cone = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["cone"].ConnectionString);
            cone.Open();
            string query = "SELECT C.Id, C.Fecha, U.Nombre AS Usuario, ES.Descripcion AS EstadoSalidaMaterial, IdCliente, PC.ApellidoPaterno + ' ' + Pc.ApellidoMaterno + ', ' +pc.Nombres AS NombreRazonSocial " +
                            "FROM SalidaMaterial C" +
                            "	 LEFT JOIN Cliente CL ON CL.IdCliente = C.IdClienteNatural " +
                            "	 INNER JOIN Persona PC ON PC.Id = CL.IdPersona " +
                            "	 INNER JOIN Usuario U ON C.IdUsuario = U.id " +
                            "	 INNER JOIN Estado ES ON ES.Id = C.IdEstado " +
                            "UNION ALL " +
                            "SELECT C.Id, C.Fecha, U.Nombre, ES.Descripcion, IdClienteJuridico, PE.RazonSocial " +
                            "FROM SalidaMaterial C " +
                            "	 LEFT JOIN Empresa E ON C.IdClienteJuridico = E.Id " +
                            "	 INNER JOIN Persona PE ON PE.ID = E.IdPersona " +
                            "	 INNER JOIN Usuario U ON C.IdUsuario = U.id " +
                            "	 INNER JOIN Estado ES ON ES.Id = C.IdEstado " +
                            "UNION ALL " +
                            "SELECT SM.Id ,SM.Fecha ,U.Nombre ,ES.Descripcion ,SM.IdEmpleado ,PE.ApellidoPaterno + ' ' + PE.ApellidoMaterno + ', ' + PE.Nombres " +
                            "FROM SalidaMaterial SM " +
                            "	 LEFT JOIN Empleado E ON SM.IdEmpleado = E.Id " +
                            "	 INNER JOIN Persona PE ON PE.Id = E.IdPersona " +
                            "	 INNER JOIN Usuario U ON SM.IdUsuario = U.id " +
                            "	 INNER JOIN Estado ES ON SM.IdEstado = ES.Id " +
                            "ORDER BY 1 DESC ";

            SqlCommand cmd = new SqlCommand(query, cone);
            dt.Load(cmd.ExecuteReader());
            cone.Close();
            return dt;
        }
        public bool ConvertirCotizacion_OrdenVenta(int IdCotizacion, int IdUsuario)
        {
            bool retorno = false;
            SqlConnection cone = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["cone"].ConnectionString);
            cone.Open();
            string query = "EXEC [dbo].[St_P_ConvertirCotizacion_OrdenVenta] " + IdCotizacion + ", " + IdUsuario;

            SqlCommand cmd = new SqlCommand(query, cone);
            try
            {
                if (cmd.ExecuteNonQuery() > 0)
                    retorno = true;
            }
            catch (Exception)
            {
                retorno = false;
            }
            return retorno;
        }
        public int? ObtenerEstadoSalidaMateriales(int IdCotizacion)
        {
            return (from r in _contexto.Cotizacion
                    where r.Id == IdCotizacion
                    select r.IdEstado).FirstOrDefault();
        }
    }
}
