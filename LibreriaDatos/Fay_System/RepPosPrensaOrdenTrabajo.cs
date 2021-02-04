using LibreriaDatos.DTO;
using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace LibreriaDatos.Fay_System
{
    public class RepPosPrensaOrdenTrabajo : Repositorio<PosPrensaOrdenTrabajo>
    {
        public RepPosPrensaOrdenTrabajo(FayceEntities contexto) : base(contexto)
        {

        }
        public PosPrensaOrdenTrabajo ObtenerPosPrensaOrdenTrabajo_IdOrden(int idOrdenTrabajo)
        {
            return (from pp in _contexto.PosPrensaOrdenTrabajo
                    where pp.IdOrdenTrabajo == idOrdenTrabajo
                    select pp).FirstOrDefault();
        }
    }
}
