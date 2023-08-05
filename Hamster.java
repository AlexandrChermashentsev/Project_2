

public class Hamster extends Pet{
    String cage; 

    public Hamster(int id, String name, String birthdate, boolean thoroughbred) {
        super(id, name, birthdate, thoroughbred);
    }

    public static void Comands(){
        System.out.println("Это животное не выполняет команд");
    }
    
}
