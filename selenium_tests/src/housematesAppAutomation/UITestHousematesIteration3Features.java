package housematesAppAutomation;
import static org.junit.Assert.*;

import java.io.File;
import java.util.ArrayList;
import java.util.List;
import java.util.Random;
import java.util.regex.Pattern;
import java.util.concurrent.TimeUnit;

import org.openqa.selenium.*;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.firefox.FirefoxDriver;
import org.openqa.selenium.interactions.Actions;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.Select;
import org.openqa.selenium.support.ui.WebDriverWait;
import org.testng.annotations.Test;

import com.thoughtworks.selenium.*;

/**
 * Tests Announcements delete, edit, Tasks
 * @author Kevin Sung
 *
 */
public class UITestHousematesIteration3Features {
	public static String chromedriverPath = "C:/chromedriver.exe";
	private static WebDriver driver;
	public static String user1;
	public static String user2;
	public static String household;
	public static String testURL = "https://housemates1-ksungregen.c9.io/";
	
	/**
	 * Tests Announcements Delete and Edit
	 * @throws Exception
	 */
	@Test
	public static void TestAnnouncementDeleteEdit () throws Exception {
		File file = new File(chromedriverPath);
		System.setProperty("webdriver.chrome.driver", file.getAbsolutePath());
		driver = new ChromeDriver();
		driver.get(testURL);
		
		Random rand = new Random();
	    user1 = "user" + String.valueOf(rand.nextInt(Integer.MAX_VALUE - 100000)+100000);
	    user2 = "user" + String.valueOf(rand.nextInt(Integer.MAX_VALUE - 100000)+100000);
	    household = "My Test Household";
	    
		driver.findElement(By.id("user_name")).sendKeys(user1);
		driver.findElement(By.id("user_email")).sendKeys(user1+ "@test.com");
		driver.findElement(By.id("user_password")).sendKeys("password");
		driver.findElement(By.id("user_password_confirmation")).sendKeys("password");
		driver.findElement(By.name("commit")).click();
		
		assertEquals(testURL + "invites", driver.getCurrentUrl());
		driver.findElement(By.xpath("//*[@value='Create a Household']")).click();
		
		assertEquals(testURL + "households/new?", driver.getCurrentUrl());
		driver.findElement(By.id("household_name")).sendKeys(household);
		driver.findElement(By.xpath("//*[@value='Create household']")).click();
		
		assertEquals(testURL + "home", driver.getCurrentUrl());
		driver.findElement(By.id("invite_email")).sendKeys(user2 + "@test.com");
		driver.findElement(By.xpath("//*[@value='Invite']")).click();
		
		driver.findElement(By.xpath("//*[@href='/logout']")).click();
		
		driver.findElement(By.id("user_name")).sendKeys(user2);
		driver.findElement(By.id("user_email")).sendKeys(user2 + "@test.com");
		driver.findElement(By.id("user_password")).sendKeys("password");
		driver.findElement(By.id("user_password_confirmation")).sendKeys("password");
		driver.findElement(By.name("commit")).click();
		
		assertEquals(testURL + "invites", driver.getCurrentUrl());
		driver.findElement(By.xpath("//*[@value='Accept invite']")).click();
		
		assertEquals(testURL + "home", driver.getCurrentUrl());
	}
	
	@Test(dependsOnMethods = { "TestAnnouncementDeleteEdit" })
	public static void TestTasks() throws Exception {
		assertEquals(testURL + "home", driver.getCurrentUrl());
		driver.findElement(By.xpath("//*[@href='/tasks/show']")).click();
		while (!driver.getCurrentUrl().equals(testURL + "tasks/show")) {}
		driver.findElement(By.id("name")).sendKeys("Test Task");
		driver.findElement(By.name("commit")).click();
		while (true) {
			try {
				driver.findElements(By.xpath("//*[contains(text(),'" + "New task created" + "')]"));
				break;
			} catch (Exception e) {} //page not loaded yet
		}
		assertTrue(driver.findElements(By.xpath("//*[contains(text(),'" + "New task created" + "')]")).size() > 0);
		assertTrue(driver.findElements(By.xpath("//*[contains(text(),'" + "Test Task" + "')]")).size() > 0);

		driver.findElement(By.xpath("//*[@class='blank-profile']")).click();
		
		while (true) {
			try {
				driver.findElement(By.xpath("//*[@class='user']"));
				break;
			} catch (Exception e) {} //page not loaded yet
		}
		
		assertTrue(driver.findElements(By.xpath("//*[@class='user']")).size() > 0);
		
		driver.findElement(By.xpath("//*[@class='checkbox']")).click();
		Wait(1000);
		
		driver.findElement(By.id("name")).sendKeys("Test Task 2");
		Wait(1000);
		
		driver.findElement(By.name("commit")).click();
		Wait(1000);
		
		while (true) {
			try {
				driver.findElements(By.xpath("//*[contains(text(),'" + "New task created" + "')]"));
				break;
			} catch (Exception e) {} //page not loaded yet
		}
		assertTrue(driver.findElements(By.xpath("//*[contains(text(),'" + "New task created" + "')]")).size() > 0);
		assertTrue(driver.findElements(By.xpath("//*[contains(text(),'" + "Test Task 2" + "')]")).size() > 0);
		
		driver.findElement(By.xpath("//*[@class='btn delete-announcement btn btn-xs btn-danger']")).click();
		
		while (true) {
			try {
				driver.findElements(By.xpath("//*[contains(text(),'" + "Task successfully deleted" + "')]"));
				break;
			} catch (Exception e) {} //page not loaded yet
		}
		
		assertTrue(driver.findElements(By.xpath("//*[contains(text(),'"+ "Task successfully deleted" + "')]")).size() > 0);
	}
	
	public static void Wait(int milliseconds) {
		try {
		    Thread.sleep(milliseconds);                 //1000 milliseconds is one second.
		} catch(InterruptedException ex) {
		    Thread.currentThread().interrupt();
		}
	}
}