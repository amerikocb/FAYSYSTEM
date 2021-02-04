using LibreriaDatos.DTO;
using System.Collections.Generic;
using System.Linq;

namespace LibreriaDatos.Fay_System
{
    public class RepAdelantosOrdenVenta:Repositorio<AdelantosOrdenVenta>
    {
        public RepAdelantosOrdenVenta(FayceEntities contexto) : base(contexto)
        {
        }
        public decimal ObtenerSaldo_x_OrdenVenta(int IdOv)
        {
            var adelantos = _contexto.AdelantosOrdenVenta.Where(a => a.IdOrdenVenta == IdOv).Select(ad => (double?)ad.Monto).Sum() ?? (double?)0.0;
            var total = _contexto.OrdenVenta.Where(o => o.Id == IdOv).Select(ov => (double)ov.CostoTotal).FirstOrDefault();
            return decimal.Parse((total - adelantos).ToString());
        }
    }
}
