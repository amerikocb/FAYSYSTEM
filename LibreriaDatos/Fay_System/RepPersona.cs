using System.Linq;

namespace LibreriaDatos.Fay_System
{
    public class RepPersona:Repositorio<Persona>
    {
        public RepPersona(FayceEntities contexto) : base(contexto)
        {
        }

        public bool ObtenerPersona_x_RUC(string ruc)
        {
            Persona persona = _contexto.Persona.Where(p => p.Ruc == ruc).FirstOrDefault<Persona>();
            if (persona != null)
                return true;
            else
                return false;
        }

        public bool ObtenerPersonaCliente_x_DNI(string dni)
        {
            var persona = (from p in _contexto.Persona
                           join c in _contexto.Cliente on p.Id equals c.IdPersona
                           where p.DNI == dni
                           select c).FirstOrDefault();
            //Persona persona = _contexto.Persona.Where(p => p.DNI == dni).FirstOrDefault<Persona>();
            if (persona != null)
                return true;
            else
                return false;
        }

        public bool ObtenerPersonaEmpleado_x_DNI(string dni)
        {
            var persona = (from p in _contexto.Persona
                           join e in _contexto.Empleado on p.Id equals e.IdPersona
                           where p.DNI == dni
                           select e).FirstOrDefault();
            if (persona != null)
                return true;
            else
                return false;
        }
    }
}
