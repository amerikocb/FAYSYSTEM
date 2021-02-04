using LibreriaDatos.DTO;
using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Data.Entity.Core.EntityClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace LibreriaDatos.Fay_System
{
    public class RepRecepcionDetalle : Repositorio<RecepcionDetalle>
    {
        public RepRecepcionDetalle(FayceEntities contexto) : base(contexto)
        {
        }
        public List<DTORecepcionDetalle> ObtenerDetalleRecepcion(int IdRecepcion)
        {
            return (from rd in _contexto.RecepcionDetalle 
                    join ocd in _contexto.OrdenCompraDetalle on rd.IdOrdenCompraDetalle equals ocd.Id 
                    join um in _contexto.UnidadMedida on ocd.IdUnidadMedida equals um.Id 
                    join r in _contexto.Recepcion on rd.IdRecepcion equals r.Id
                    join prod in _contexto.Material on rd.IdMaterial equals prod.Id
                    join u in _contexto.Usuario on r.IdUsuario equals u.id
                    join e in _contexto.Estado on rd.IdEstado equals e.Id
                    join em in _contexto.Empresa on r.IdEmpresa equals em.Id
                    join p in _contexto.Persona on em.IdPersona equals p.Id
                    where rd.IdRecepcion == IdRecepcion
                    select new DTORecepcionDetalle
                    {
                        IdRecepcionDetalle = rd.Id,
                        IdOrdenCompraDetalle = rd.IdOrdenCompraDetalle,
                        Proveedor = p.RazonSocial,
                        EstadoOrdenCD = e.Descripcion,
                        IdMaterial = prod.Id,
                        Descripcion = prod.Descripcion,
                        CantidadRecibida = rd.CantidadRecibida,
                        Precio = rd.Precio,
                        Importe = (decimal)(rd.CantidadRecibida * rd.Precio),
                        UnidadMedida = um.Descripcion 
                    }).ToList();
        }
        public void InsertarValoresRecepcionDetalle(OrderedDictionary nuevosValores, int IdRecepcion)
        {
            RecepcionDetalle recDetalle = new RecepcionDetalle();
            recDetalle.IdRecepcion = IdRecepcion;
            LeerNuevosValores(recDetalle, nuevosValores);
            using (var db = new UnidadDeTrabajo())
            {
                db.RecepcionDetalle.Insertar(recDetalle);
                db.Grabar();
            }
        }
        protected void LeerNuevosValores(RecepcionDetalle item, OrderedDictionary valores)
        {
            item.IdOrdenCompraDetalle = Convert.ToInt32(valores["IdOrdenCompraDetalle"]);
            item.IdMaterial = Convert.ToInt32(valores["IdMaterial"]);
            item.IdEstado = 24;
            item.Precio = decimal.Parse(valores["Precio"].ToString());
            item.Cantidad = int.Parse(valores["Cantidad"].ToString());
            item.CantidadRecibida = int.Parse(valores["CantidadRecibida"].ToString());
            item.Importe = decimal.Parse(valores["Importe"].ToString());
            item.RecepcionTotal = valores["Cantidad"] == valores["CantidadRecibida"] ? true : false;
        }

        public double? SumaCantidadesRecibidas_x_OrdenCompra(int IdOrdenCompra)
        {
            return (from rd in _contexto.RecepcionDetalle
                    join r in _contexto.Recepcion on rd.IdRecepcion equals r.Id
                    where r.IdOrdenCompra == IdOrdenCompra select rd.CantidadRecibida).Sum();
        }
        public double? SumaCantidades_x_OrdenCompra(int IdOrdenCompra)
        {
            return (from ocd in _contexto.OrdenCompraDetalle
                    where ocd.IdOrdenCompra == IdOrdenCompra
                    select ocd.Cantidad).Sum();
        }
    }
}
