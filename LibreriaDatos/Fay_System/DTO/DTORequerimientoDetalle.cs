using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace LibreriaDatos.DTO
{
    public class DTORequerimientoDetalle
    {
        public int Id { get; set; }
        public int Material { get; set; }
        public int? Cantidad { get; set; }
        public int Proveedor { get; set; }
        public decimal? Precio { get; set; }
        public decimal Importe { get; set; }
        public string TipoMoneda { get; set; }
        public decimal? Equivalencia { get; set; }
        public decimal? PrecioDolar { get; set; }
        public int? IdUnidadMedida { get; set; }
    }
}
