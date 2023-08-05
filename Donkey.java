

public class Donkey extends Beast {

    public Donkey(int id, String name, String birthdate, int loadCapacity) {
        super(id, name, birthdate, loadCapacity);
    }
    
    public static void Comands(){
        System.out.println("Выполняемые команды животного");
    }
}
