using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace LibreriaDatos.Fay_System
{
    public class RepDepartamento:Repositorio<Departamento>
    {
        public RepDepartamento(FayceEntities contexto) : base(contexto)
        {
        }
    }
}
