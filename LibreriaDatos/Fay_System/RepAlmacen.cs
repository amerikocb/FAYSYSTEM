using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace LibreriaDatos.Fay_System
{
    public class RepAlmacen: Repositorio<Almacen>
    {
        public RepAlmacen(FayceEntities contexto) : base(contexto)
        {
        }
        public List<AlmacenEstado> ObtenerAlmacenes()
        {
            return (from a in _contexto.Almacen
                    join e in _contexto.Estado on a.IdEstado equals e.Id
                    select new AlmacenEstado
                    {
                        Id = a.Id,
                        Descripcion = a.Descripcion,
                        Estado = e.Descripcion,
                    }).OrderByDescending(al => al.Id).ToList();
        }
        public class AlmacenEstado
        {
            public int Id { get; set; }
            public string Descripcion { get; set; }
            public string Estado { get; set; }
        }
    }
}
