using LibreriaDatos.DTO;
using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace LibreriaDatos.Fay_System
{
    public class RepBodegaInventarioCorte:Repositorio<BodegaInventarioOrdenTrabajo>
    {
        public RepBodegaInventarioCorte(FayceEntities contexto) : base(contexto)
        {

        }

        public List<BodegaInventarioOrdenTrabajo> ObtenerDatosBodegaInventario_IdOT(int IdOrdenTrabajo)
        {
            return (from bi in _contexto.BodegaInventarioOrdenTrabajo
                    where bi.IdOrdenTrabajo == IdOrdenTrabajo
                    select bi
                    ).ToList();
        }

        public void InsertarValoresBodegaInventario(OrderedDictionary nuevosValores, int IdOrdenTrabajo)
        {
            BodegaInventarioOrdenTrabajo bodegaInventario = new BodegaInventarioOrdenTrabajo();
            bodegaInventario.IdOrdenTrabajo = IdOrdenTrabajo;
            LeerNuevosValores(bodegaInventario, nuevosValores);
            using (var db = new UnidadDeTrabajo())
            {
                db.BodegaInventarioCorte.Insertar(bodegaInventario);
                db.Grabar();
            }
        }
        protected void LeerNuevosValores(BodegaInventarioOrdenTrabajo item, OrderedDictionary valores)
        {
            item.Medida = valores["Medida"]?.ToString();
            item.Trabajo = valores["Trabajo"]?.ToString();
            item.PliegoPrisma = valores["PliegoPrisma"]?.ToString();
            item.Descripcion = valores["Descripcion"]?.ToString();
            item.TamañoCorte = valores["TamañoCorte"]?.ToString();
            item.Demasia = valores["Demasia"]?.ToString();
            item.TotalCorte = valores["TotalCorte"]?.ToString();
        }
        public void ActualizarValoresBodegaInventario(OrderedDictionary keys, OrderedDictionary nuevosValores)
        {
            var id = Convert.ToInt32(keys["IdBodegaInventarioOrdenProduccion"]);
            BodegaInventarioOrdenTrabajo bodegaInventario = _contexto.BodegaInventarioOrdenTrabajo.Where(cd => cd.IdBodegaInventarioOrdenProduccion == id).FirstOrDefault<BodegaInventarioOrdenTrabajo>();
            LeerNuevosValores(bodegaInventario, nuevosValores);
            _contexto.SaveChanges();
        }
        public void EliminarBodegaInventario(OrderedDictionary keys)
        {
            var id = Convert.ToInt32(keys["IdBodegaInventarioOrdenProduccion"]);
            OrdenVentaDetalle reqDetalle = _contexto.OrdenVentaDetalle.Where(cd => cd.Id == id).FirstOrDefault<OrdenVentaDetalle>();
            reqDetalle.IdEstado = 42;
            _contexto.SaveChanges();
        }
    }
}
