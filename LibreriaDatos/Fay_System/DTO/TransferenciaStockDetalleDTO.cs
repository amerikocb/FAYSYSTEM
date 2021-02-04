using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace LibreriaDatos.DTO
{
    public class TransferenciaStockDetalleDTO
    {
        public int Id { get; set; }
        public string Material { get; set; }
        public double Cantidad { get; set; }
        public DateTime? FechaCreacion { get; set; }
    }
}
