using LibreriaDatos.DTO;
using System;
using System.Collections.Generic;
using System.Data.Entity.Core.EntityClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;
using System.Data.SqlClient;

namespace LibreriaDatos.Fay_System
{
    public class RepOrdenCompraDetalle : Repositorio<OrdenCompraDetalle>
    {
        public RepOrdenCompraDetalle(FayceEntities contexto) : base(contexto)
        {
        }
        public List<DTOOrdenCompraDetalle> ObtenerDetalleOrdenCompra(int IdOrdenCompra)
        {
            return (from ocd in _contexto.OrdenCompraDetalle
                    join um in _contexto.UnidadMedida on ocd.IdUnidadMedida equals um.Id 
                    join o in _contexto.OrdenCompra on ocd.IdOrdenCompra equals o.Id
                    join prod in _contexto.Material on ocd.IdMaterial equals prod.Id
                    join u in _contexto.Usuario on o.IdUsuario equals u.id
                    join e in _contexto.Estado on o.IdEstado equals e.Id
                    join em in _contexto.Empresa on o.IdEmpresa equals em.Id
                    join p in _contexto.Persona on em.IdPersona equals p.Id
                    where ocd.IdOrdenCompra == IdOrdenCompra
                    select new DTOOrdenCompraDetalle
                    {
                        IdOrdenCD = ocd.Id,
                        Proveedor = p.RazonSocial,
                        EstadoOrdenCD= e.Descripcion,
                        IdMaterial = prod.Id,
                        Descripcion = prod.Descripcion,
                        Cantidad = ocd.Cantidad,
                        Precio = ocd.Precio,
                        Importe = (decimal)(ocd.Cantidad * ocd.Precio),
                        UnidadMedida = um.Descripcion 
                    }).ToList();
        }
        public void InsertarOrdenCompraDetalle_x_OrdenCompra(OrdenCompra ordenCompra, int? Idproveedor)
        {
            _contexto.Database.ExecuteSqlCommand("INSERT INTO OrdenCompraDetalle (IdOrdenCompra, IdMaterial, Cantidad, Precio, IdEstado, IdUnidadMedida, PrecioDolar) " +
                                            "SELECT "+ ordenCompra.Id +", IdMaterial, Cantidad, Precio, 13, IdUnidadMedida, PrecioDolar "+
                                            "FROM RequerimientoDetalle WHERE IdEstado = 29 AND IdRequerimiento = " + ordenCompra.IdRequerimiento +
                                            "AND IdProveedor = " + Idproveedor);
        }

        public DataTable ObtenerDetalleOrdenCompraPorIdOC(int IdOrdenCompra)
        {
            DataTable dt = new DataTable();
            SqlConnection cone = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["cone"].ConnectionString);
            cone.Open();
            string query = "DECLARE @Select bit " +
                    "SET @Select='False'" +
                    "SELECT " +
                         "@select 'Seleccion', " +
                         " OrdenCompraDetalle.Id AS [IdOrdenCompraDetalle], " +
                         " OrdenCompraDetalle.IdOrdenCompra, " +
                         " OrdenCompraDetalle.IdMaterial, " +
                         " Material.Descripcion, " +
                         " CAST((OrdenCompraDetalle.Cantidad-ISNULL((Select SUM(RD.CantidadRecibida) " +
                                " from RecepcionDetalle RD where RD.IdOrdenCompraDetalle=OrdenCompraDetalle.Id),0)) AS INT) as CantidadRecibida, " +
                         " CAST((OrdenCompraDetalle.Cantidad-ISNULL((Select SUM(RD.CantidadRecibida) " +
                                " from RecepcionDetalle RD where RD.IdOrdenCompraDetalle=OrdenCompraDetalle.Id),0)) AS INT) as Cantidad, " +
                         "UM.Descripcion AS UnidadMedida, " +
                         " OrdenCompraDetalle.Precio, " +
                         " OrdenCompraDetalle.Precio * OrdenCompraDetalle.Cantidad AS Importe,  " +
                         " OrdenCompraDetalle.IdEstado, " +
                         " Estado.Descripcion AS Estado " +
                    " FROM " +
                        " OrdenCompraDetalle " +
                        " INNER JOIN UnidadMedida UM on UM.Id = OrdenCompraDetalle.IdUnidadMedida " +
                        " INNER JOIN  Material ON OrdenCompraDetalle.IdMaterial = Material.Id " +
                        " INNER JOIN  Estado ON OrdenCompraDetalle.IdEstado = Estado.Id " +
                        " WHERE OrdenCompraDetalle.IdEstado = 13 " +
                        " AND OrdenCompraDetalle.IdOrdenCompra = " + IdOrdenCompra +
                        " AND CAST((OrdenCompraDetalle.Cantidad-ISNULL((Select SUM(RD.CantidadRecibida)  " +
                              " FROM RecepcionDetalle RD " +
                              " WHERE RD.IdOrdenCompraDetalle = OrdenCompraDetalle.Id),0)) AS Decimal(18,2))>0 ";
            SqlCommand cmd = new SqlCommand(query, cone);
            dt.Load(cmd.ExecuteReader());
            cone.Close();
            return dt;
        }
    }
}
