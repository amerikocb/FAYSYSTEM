using LibreriaDatos.DTO;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace LibreriaDatos.Fay_System
{
    public class RepAutocorriativoOT : Repositorio<AutoCorriativoOrdenTrabajo>
    {
        public RepAutocorriativoOT(FayceEntities contexto) : base(contexto)
        {
        }

        public AutoCorriativoOrdenTrabajo ObtenerAutocorriativo_IdOrden(int idOrdenTrabajo)
        {
            return (from pp in _contexto.AutoCorriativoOrdenTrabajo
                    where pp.IdOrdenTrabajo == idOrdenTrabajo
                    select pp).FirstOrDefault();
        }
    }
}
