using LibreriaDatos.DTO;
using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace LibreriaDatos.Fay_System
{
    public class RepOrdenVentaDetalle : Repositorio<OrdenVentaDetalle>
    {
        public RepOrdenVentaDetalle(FayceEntities contexto) : base(contexto)
        {

        }
        public List<DTOOrdenVentaDetalle> ObtenerDetalleOrdenVenta(int IdOrdenVenta, int Opcion)
        {
            if (Opcion == 1)
            {
                return (from c in _contexto.OrdenVenta
                        join cd in _contexto.OrdenVentaDetalle on c.Id equals cd.IdOrdenVenta
                        join s in _contexto.Servicio on cd.IdServicio equals s.Id
                        join um in _contexto.UnidadMedida on cd.IdUnidadMedida equals um.Id
                        where cd.IdOrdenVenta == IdOrdenVenta && cd.IdEstado == 41
                        select new DTOOrdenVentaDetalle
                        {
                            Id = cd.Id,
                            ItemDescripcion = s.Descripcion,
                            IdServicio = s.Id,
                            Cantidad = cd.Cantidad,
                            Importe = (decimal)(cd.Cantidad * cd.Precio),
                            Precio = cd.Precio,
                            TipoMoneda = cd.TipoMoneda,
                            Equivalencia = cd.Equivalencia,
                            IdUnidadMedida = um.Id,
                            IdMaterial = cd.IdMaterial,
                            IdAlmacen = cd.IdAlmacen,
                            Observaciones = cd.Observaciones
                        }).OrderByDescending(rde => rde.Id).ToList();
            }
            else
            {
                return (from c in _contexto.OrdenVenta
                        join cd in _contexto.OrdenVentaDetalle on c.Id equals cd.IdOrdenVenta
                        join s in _contexto.Material on cd.IdMaterial equals s.Id
                        join um in _contexto.UnidadMedida on cd.IdUnidadMedida equals um.Id
                        join st in _contexto.Stock on cd.IdMaterial equals st.IdMaterial
                        join al in _contexto.Almacen on cd.IdAlmacen equals al.Id 
                        where cd.IdOrdenVenta == IdOrdenVenta && cd.IdEstado == 41 && st.IdAlmacen == cd.IdAlmacen
                        select new DTOOrdenVentaDetalle
                        {
                            Id = cd.Id,
                            ItemDescripcion = s.Descripcion,
                            IdServicio = s.Id,
                            Cantidad = cd.Cantidad,
                            Importe = (decimal)(cd.Cantidad * cd.Precio),
                            Precio = cd.Precio,
                            TipoMoneda = cd.TipoMoneda,
                            Equivalencia = cd.Equivalencia,
                            IdUnidadMedida = um.Id,
                            IdMaterial = cd.IdMaterial,
                            IdAlmacen = cd.IdAlmacen,
                            Stock = st.Stock1
                        }).OrderByDescending(rde => rde.Id).ToList();
            }
        }
        public void InsertarValoresOrdenVentaDetalle(OrderedDictionary nuevosValores, int IdOrdenVenta, decimal precioDolar)
        {
            OrdenVentaDetalle cotDetalle = new OrdenVentaDetalle();
            cotDetalle.IdOrdenVenta = IdOrdenVenta;
            cotDetalle.PrecioDolar = precioDolar;
            LeerNuevosValores(cotDetalle, nuevosValores);
            using (var db = new UnidadDeTrabajo())
            {
                db.OrdenVentaDetalle.Insertar(cotDetalle);
                db.Grabar();
            }
        }
        protected void LeerNuevosValores(OrdenVentaDetalle item, OrderedDictionary valores)
        {
            item.Observaciones = valores["Observaciones"] != null ? valores["Observaciones"].ToString() : null;
            if (valores["IdServicio"] != null)
                item.IdServicio = int.Parse(valores["IdServicio"].ToString());
            else
                item.IdServicio = null;
            if (valores["IdMaterial"] != null)
                item.IdMaterial = int.Parse(valores["IdMaterial"].ToString());
            else
                item.IdMaterial = null;
            if (valores["IdAlmacen"] != null)
                item.IdAlmacen = int.Parse(valores["IdAlmacen"].ToString());
            else
                item.IdAlmacen = null;
            item.IdEstado = 41;
            item.Precio = decimal.Parse(valores["Precio"].ToString());
            //item.AfectaIGV = true;
            item.Cantidad = int.Parse(valores["Cantidad"].ToString());
            item.IdUnidadMedida = int.Parse(valores["IdUnidadMedida"].ToString());
            if (valores["TipoMoneda"] != null)
                item.TipoMoneda = valores["TipoMoneda"].ToString();
            else
                item.TipoMoneda = "Soles";
            if (valores["Equivalencia"] != null)
                item.Equivalencia = decimal.Parse(valores["Equivalencia"].ToString());
            else
                item.Equivalencia = 0;
            item.Observaciones = valores["Observaciones"] != null ? valores["Observaciones"].ToString() : null;
        }
        public void ActualizarOrdenVentaDetalle(OrderedDictionary keys, OrderedDictionary nuevosValores, decimal precioDolar)
        {
            var id = Convert.ToInt32(keys["Id"]);
            OrdenVentaDetalle cotDetalle = _contexto.OrdenVentaDetalle.Where(cd => cd.Id == id).FirstOrDefault<OrdenVentaDetalle>();
            cotDetalle.PrecioDolar = precioDolar;
            LeerNuevosValores(cotDetalle, nuevosValores);
            _contexto.SaveChanges();
        }
        public void EliminarOrdenVentaDetalle(OrderedDictionary keys)
        {
            var id = Convert.ToInt32(keys["Id"]);
            OrdenVentaDetalle reqDetalle = _contexto.OrdenVentaDetalle.Where(cd => cd.Id == id).FirstOrDefault<OrdenVentaDetalle>();
            reqDetalle.IdEstado = 42;
            _contexto.SaveChanges();
        }
        public List<int> ObtenerProveedoresPorRequerimiento(int IdRequerimiento)
        {
            return (from rd in _contexto.RequerimientoDetalle
                    where rd.IdRequerimiento == IdRequerimiento
                    select rd.IdProveedor).Distinct().ToList();
            //_contexto.RequerimientoDetalle.Where(rd => rd.IdRequerimiento == IdRequerimiento).ToList();
        }
        public int ContarDetalleOrdenVentaMayorStock(int IdOrdenVenta)
        {
            //return (from ovd in _contexto.OrdenVentaDetalle
            //        join st in _contexto.Stock on ovd.IdMaterial equals st.IdMaterial
            //        where ovd.IdOrdenVenta == IdOrdenVenta && ovd.Cantidad > st.Stock1
            //        select ovd.Id).Count();
            return 0;
        }

        public decimal ObtenerTotalOrdenVenta(int IdOrdenVenta)
        {
            return (from ov in _contexto.OrdenVenta
                    join ovd in _contexto.OrdenVentaDetalle on ov.Id equals ovd.IdOrdenVenta
                    where ovd.IdOrdenVenta == IdOrdenVenta && ovd.IdEstado == 41
                    select ovd.Cantidad * ovd.Precio).Sum();
        }
    }
}
