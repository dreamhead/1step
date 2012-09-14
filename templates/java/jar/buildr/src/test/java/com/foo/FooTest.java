import org.junit.Test;
import static org.junit.Assert.assertThat;
import static org.hamcrest.CoreMatchers.is;

public class FooTest {
	@Test
	public void should_say_hello_to_someone() {
		assertThat(new Foo().hello("bar"), is("Hello, bar"));
	}
}