using LibreriaDatos.DTO;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace LibreriaDatos.Fay_System
{
    public class RepEstado:Repositorio<Estado>
    {
        public RepEstado(FayceEntities contexto) : base(contexto)
        {
        }

        public List<Estado> ObtenerEstado_x_Tipo(int IdTipoEstado)
        {
            return _contexto.Estado.Where(e => e.IdTipoEstado == IdTipoEstado).ToList();
        }

    }
}
