using System;
using System.Data;
using System.Data.SqlClient;
using System.Linq;

namespace LibreriaDatos.Fay_System
{
    public class RepCotizacion : Repositorio<Cotizacion>
    {
        public RepCotizacion(FayceEntities contexto) : base(contexto)
        {
        }
        public DataTable ObtenerListaCotizaciones()
        {
            DataTable dt = new DataTable();
            SqlConnection cone = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["cone"].ConnectionString);
            cone.Open();
            string query = "SELECT C.Id, C.Fecha, U.Nombre AS Usuario, ES.Descripcion AS EstadoCotizacion, IdCliente, PC.ApellidoPaterno + ' ' + Pc.ApellidoMaterno + ', ' +pc.Nombres AS NombreRazonSocial " +
                            "FROM Cotizacion C" +
                            "	 LEFT JOIN Cliente CL ON CL.IdCliente = C.IdClienteNatural " +
                            "	 INNER JOIN Persona PC ON PC.Id = CL.IdPersona " +
                            "	 INNER JOIN Usuario U ON C.IdUsuario = U.id " +
                            "	 INNER JOIN Empleado EM ON EM.Id = U.IdEmpleado " +
                            "	 INNER JOIN Persona PE ON PE.Id = EM.IdPersona " +
                            "	 INNER JOIN Estado ES ON ES.Id = C.IdEstado " +
                            "UNION ALL " +
                            "SELECT C.Id, C.Fecha, U.Nombre, ES.Descripcion, IdClienteJuridico, PE.RazonSocial " +
                            "FROM Cotizacion C " +
                            "	 LEFT JOIN Empresa E ON C.IdClienteJuridico = E.Id " +
                            "	 INNER JOIN Persona PE ON PE.ID = E.IdPersona " +
                            "	 INNER JOIN Usuario U ON C.IdUsuario = U.id " +
                            "	 INNER JOIN Empleado EM ON EM.Id = U.IdEmpleado " +
                            "	 INNER JOIN Persona PEM ON PEM.Id = EM.IdPersona " +
                            "	 INNER JOIN Estado ES ON ES.Id = C.IdEstado " +
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
            catch (Exception ex)
            {
                retorno = false;
            }
            return retorno;
        }
        public int? ObtenerEstadoCotizacion(int IdCotizacion)
        {
            return (from r in _contexto.Cotizacion
                    where r.Id == IdCotizacion
                    select r.IdEstado).FirstOrDefault();
        }
    }
}
