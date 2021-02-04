using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace LibreriaDatos.Fay_System.DTO
{
    public class AjusteInventarioDetalleDTO
    {
        public int Id { get; set; }
        public int IdMaterial { get; set; }
        public string Material { get; set; }
        public double  Cantidad { get; set; }
        //public string Estado { get; set; }
    }
}
