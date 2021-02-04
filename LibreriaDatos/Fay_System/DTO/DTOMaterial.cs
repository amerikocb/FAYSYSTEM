using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace LibreriaDatos.Fay_System.DTO
{
    public class DTOMaterial
    {
        public int IdMaterial { get; set; }
        public string Codigo { get; set; }
        public string Descripcion { get; set; }
        public int IdAlmacen { get; set; }
        public DateTime? Fecha { get; set; }
        public string Usuario { get; set; }
        public string Estado { get; set; }
        public double? Costo { get; set; }
        public double? Precio { get; set; }
        public double UnitsStock { get; set; }
        public int IdEstado { get; set; }
        public int? IdUsuario { get; set; }
    }
}
