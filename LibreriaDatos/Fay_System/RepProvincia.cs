using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace LibreriaDatos.Fay_System
{
    public class RepProvincia:Repositorio<Provincia>
    {
        public RepProvincia(FayceEntities contexto) : base(contexto)
        {
        }
        public List<Provincia> ObtenerProvinciasPorDepartamento(int IdDepartamento)
        {
            return _contexto.Provincia.Where(d => d.IdDepa == IdDepartamento).ToList();
        }
    }
}
