using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace LibreriaDatos.Fay_System.DTO
{
    public class DTOMenuBA
    {
        //public int IdMenuBA { get; set; }
        public string MenuBANombre { get; set; }
        //public string MenuBADescripcion { get; set; }
        public Nullable<int> IdMenuBAPadre { get; set; }
        public int MenuBAPosicion { get; set; }
        public string MenuBAIcono { get; set; }
        //public bool MenuBAHabilitado { get; set; }
        public string MenuBAUrl { get; set; }

        public List<DTOMenuBA> Hijos { get; set; }
    }
}
