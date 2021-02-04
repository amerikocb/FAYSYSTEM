using LibreriaDatos.Fay_System.DTO;
using System.Collections.Generic;
using System.Linq;

namespace LibreriaDatos.Fay_System
{
    public class RepComprobanteVentaDetalle: Repositorio<ComprobanteVentaDetalle>
    {
        public RepComprobanteVentaDetalle(FayceEntities contexto) : base(contexto)
        {
        }

        public List<DTOComprobanteDetalle> ObtenerMaterialesCv_x_IdComprobante(int IdComprobante)
        {
            return (from cvd in _contexto.ComprobanteVentaDetalle
                    join m in _contexto.Material on cvd.IdMaterial equals m.Id
                    join a in _contexto.Almacen on cvd.IdAlmacen equals a.Id
                    join ovd in _contexto.OrdenVentaDetalle on cvd.IdOrdenVentaDetalle equals ovd.Id
                    join um in _contexto.UnidadMedida on ovd.IdUnidadMedida equals um.Id
                    where cvd.IdComprobanteVenta == IdComprobante
                    select new DTOComprobanteDetalle
                    {
                        Id = cvd.Id,
                        Material = m.Descripcion,
                        Almacen = a.Descripcion,
                        UnidadMedida = um.Descripcion,
                        Precio = cvd.Precio,
                        Cantidad = cvd.Cantidad,
                        Importe = cvd.Cantidad * cvd.Precio
                    }).ToList();
        }

        public List<DTOComprobanteDetalle> ObtenerServiciosCv_x_IdComprobante(int IdComprobante)
        {
            return (from cvd in _contexto.ComprobanteVentaDetalle
                    join s in _contexto.Servicio on cvd.IdServicio equals s.Id
                    join ovd in _contexto.OrdenVentaDetalle on cvd.IdOrdenVentaDetalle equals ovd.Id
                    join um in _contexto.UnidadMedida on ovd.IdUnidadMedida equals um.Id
                    where cvd.IdComprobanteVenta == IdComprobante
                    select new DTOComprobanteDetalle
                    {
                        Id = cvd.Id,
                        Servicio = s.Descripcion,
                        UnidadMedida = um.Descripcion,
                        Precio = cvd.Precio,
                        Cantidad = cvd.Cantidad,
                        Importe = cvd.Cantidad * cvd.Precio
                    }).ToList();

        }
    }
}