package pl.kacper.person;

import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping(path = "/person")
@RequiredArgsConstructor
public class PersonController {

    private final PersonRepository PersonRepository;


    @PostMapping
    public Long create(@RequestBody Person Person){
        return PersonRepository.save(Person).getId();
    }

    @GetMapping("/{id}")
    public Person getOne(@PathVariable Long id){
        return PersonRepository.findById(id).orElseThrow(() -> new IllegalArgumentException("Could not find Person with id " + id));
    }

    @GetMapping("/all")
    public List<Person> getAll(){
        return PersonRepository.findAll();
    }
}
