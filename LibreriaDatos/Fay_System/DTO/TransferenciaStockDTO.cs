using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace LibreriaDatos.DTO
{
    public class TransferenciaStockDTO
    {
        public int Id { get; set; }
        public string AlmacenOrigen { get; set; }
        public string AlmacenDestino { get; set; }
        public DateTime Fecha { get; set; }
        public string Usuario { get; set; }
        public DateTime FechaCreacion { get; set; }
        public string Motivo { get; set; }
}
}
