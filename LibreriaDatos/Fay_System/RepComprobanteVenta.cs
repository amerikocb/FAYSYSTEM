using System.Linq;

namespace LibreriaDatos.Fay_System
{
    public class RepComprobanteVenta: Repositorio<ComprobanteVenta>
    {
        public RepComprobanteVenta(FayceEntities contexto) : base(contexto)
        {
        }

        public int ObtenerComprobanteId_OrdenVenta(int IdOrdenVenta)
        {
            return _contexto.ComprobanteVenta.Where(cv => cv.IdOrdenVenta == IdOrdenVenta).FirstOrDefault<ComprobanteVenta>().IdComprobanteVenta;
        }

        public int ObtenerNotasCreaditoAO_x_IdComprobante(int IdComprobante)
        {
            return _contexto.ComprobanteVenta.Where(cv => cv.IdComprobanteVentaRef == IdComprobante && cv.IdTipoDocumento == 4).Count();
        }
    }
}