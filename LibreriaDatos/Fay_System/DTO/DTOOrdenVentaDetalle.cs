using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace LibreriaDatos.DTO
{
    public class DTOOrdenVentaDetalle
    {
        public int Id { get; set; }
        public string ItemDescripcion { get; set; }
        public int? Cantidad { get; set; }
        public decimal? Precio { get; set; }
        public decimal Importe { get; set; }
        public int? IdServicio { get; set; }
        public string TipoMoneda { get; set; }
        public decimal? Equivalencia { get; set; }
        public decimal? PrecioDolar { get; set; }
        public int IdUnidadMedida { get; set; }
        public int? IdMaterial { get; set; }
        public int? IdAlmacen { get; set; }
        public double Stock { get; set; }
        public string Observaciones { get; set; }
    }
}
