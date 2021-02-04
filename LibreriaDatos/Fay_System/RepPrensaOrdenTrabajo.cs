using LibreriaDatos.DTO;
using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace LibreriaDatos.Fay_System
{
    public class RepPrensaOrdenTrabajo:Repositorio<PrensaOrdenTrabajo>
    {
        public RepPrensaOrdenTrabajo(FayceEntities contexto) : base(contexto)
        {

        }

        public List<PrensaOrdenTrabajo> ObtenerDatosPrensa_IdOT(int IdOrdenTrabajo)
        {
            return (from po in _contexto.PrensaOrdenTrabajo
                    where po.IdOrdenTrabajo == IdOrdenTrabajo
                    select po
                    ).ToList();
        }

        public void InsertarValoresPrensaOrdenTrabajo(OrderedDictionary nuevosValores, int IdOrdenTrabajo)
        {
            PrensaOrdenTrabajo prensaOrden = new PrensaOrdenTrabajo();
            prensaOrden.IdOrdenTrabajo = IdOrdenTrabajo;
            LeerNuevosValores(prensaOrden, nuevosValores);
            using (var db = new UnidadDeTrabajo())
            {
                db.PrensaOrdenTrabajo.Insertar(prensaOrden);
                db.Grabar();
            }
        }
        protected void LeerNuevosValores(PrensaOrdenTrabajo item, OrderedDictionary valores)
        {
            try
            {
                item.Trabajo = valores["Trabajo"]?.ToString() ;
                item.Tamaño = valores["Tamaño"]?.ToString();
                item.Tiros = valores["Tiros"]?.ToString();
                item.Demasia = valores["Demasia"]?.ToString();
                item.Tira = valores["Tira"]?.ToString();
                item.Retira = valores["Retira"]?.ToString();
                item.P_Exceso = valores["P_Exceso"]?.ToString();
                item.T = valores["T"]?.ToString();
                item.T_R = valores["T_R"]?.ToString();
                item.T_Plus_R = valores["T_Plus_R"]?.ToString();
                item.Maquina = valores["Maquina"]?.ToString();
                item.Observaciones = valores["Observaciones"]?.ToString();
            }
            catch(Exception ex)
            {
                string m = ex.Message;
            }
        }
        public void ActualizarValoresPrensaOrden(OrderedDictionary keys, OrderedDictionary nuevosValores)
        {
            var id = Convert.ToInt32(keys["IdPrensaOrdenTrabajo"]);
            PrensaOrdenTrabajo prensaOrden = _contexto.PrensaOrdenTrabajo.Where(cd => cd.IdPrensaOrdenTrabajo == id).FirstOrDefault<PrensaOrdenTrabajo>();
            LeerNuevosValores(prensaOrden, nuevosValores);
            _contexto.SaveChanges();
        }
        public void EliminarBodegaInventario(OrderedDictionary keys)
        {
            var id = Convert.ToInt32(keys["IdPrensaOrdenTrabajo"]);
            OrdenVentaDetalle reqDetalle = _contexto.OrdenVentaDetalle.Where(cd => cd.Id == id).FirstOrDefault<OrdenVentaDetalle>();
            reqDetalle.IdEstado = 42;
            _contexto.SaveChanges();
        }
    }
}
