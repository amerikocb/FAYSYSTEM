using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace LibreriaDatos.Fay_System.DTO
{
    public class DTOMvtoMateriales
    {
        public int IdTransaccion { get; set; }
        public DateTime FechaTransaccion { get; set; }
        public string Accion { get; set; }
        public string Operacion { get; set; }
        public int IdMaterial { get; set; }
        public int StockFecha { get; set; }
        public int CantidadAlterada { get; set; }
        public int StockResultante { get; set; }
        public string Usuarioo { get; set; }
        public int IdAlmacen { get; set; }
    }
}
