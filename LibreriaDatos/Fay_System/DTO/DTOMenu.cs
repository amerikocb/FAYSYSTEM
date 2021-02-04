using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace LibreriaDatos.Fay_System.DTO
{
    public class DTOMenu
    {
        public int IdMenu { get; set; }
        public string NombreMenu { get; set; }
        public int? IdMenuPadre { get; set; }
        public int Posicion { get; set; }
        public string Icono { get; set; }
        public string Url { get; set; }

        public List<DTOMenuBA> Hijos { get; set; }
    }
}
