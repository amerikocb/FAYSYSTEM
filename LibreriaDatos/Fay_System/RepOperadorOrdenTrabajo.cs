using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace LibreriaDatos.Fay_System
{
    public class RepOperadorOrdenTrabajo:Repositorio<OrdenTrabajo>
    {
        public RepOperadorOrdenTrabajo(FayceEntities contexto) : base(contexto)
        {

        }
        
        //public List<OperadorOrdenTrabajo> ObtenerOperadoresOrdenVenta(int IdOrdenVenta)
        //{
        //    return (from oot in _contexto.OperadorOrdenTrabajo
        //            join 
        //        )
        //}
    }
}
