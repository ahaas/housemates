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
import org.testng.annotations.AfterMethod;
import org.testng.annotations.Test;

import com.thoughtworks.selenium.*;

/**
 * Tests User Creation, Household creation, Invite Functionality
 * @author Kevin Sung
 *
 */
public class UITestHousemates {
	public static String chromedriverPath = "C:/chromedriver.exe";
	private static WebDriver driver;
	public static String user1;
	public static String user2;
	public static String household;
	public static String testURL = "https://housemates1-ksungregen.c9.io/";
	
	/**
	 * Tests User creation, household creation, and invitation, and another user accepting invite
	 * @throws Exception
	 */
	@Test
	public static void TestUserHouseholdInvites () throws Exception {
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
		assertTrue(driver.findElements(By.xpath("//*[contains(text(),'" + user1 + "')]")).size() > 0);
	}
	
	/**Test add transactions and paid back funtionality. Depends on TestUserCreateInviteFunctionality finishing.
	 */
	@Test(dependsOnMethods = { "TestUserHouseholdInvites" })
	public static void TestTransactions () throws Exception {
		assertEquals(testURL + "home", driver.getCurrentUrl());
		driver.findElement(By.xpath("//*[@href='/transactions/show']")).click();
		boolean loading = true;
		while (loading) {
			try {
				driver.findElement(By.xpath("//*[@href='/transactions/new_item']")).click();
				loading = false;
			} catch (Exception e) {}
		}
		String randomItem = "pet penguin";
		boolean loadingPage = true;
		while (loadingPage) {
			try {
				driver.findElement(By.id("name")).sendKeys(randomItem);
				loadingPage = false;
			} catch (Exception e) {}
		}
		loadingPage = true;
		driver.findElement(By.id("amount")).clear();
		driver.findElement(By.id("amount")).sendKeys("100.50");
		driver.findElement(By.name("commit")).click();
		assertTrue(driver.findElements(By.xpath("//*[contains(text(),'" + randomItem + "')]")).size() > 0);
		
		driver.findElement(By.xpath("//*[@href='/transactions/new_payback']")).click();
		while (loadingPage) {
			try {
				driver.findElement(By.name("user_id"));
				loadingPage = false;
			} catch (Exception e) {}
		}
		loadingPage = true;
		driver.findElement(By.id("amount")).clear();
		driver.findElement(By.id("amount")).sendKeys("50.25");
		driver.findElement(By.name("commit")).click();
		while (!driver.getCurrentUrl().equals(testURL + "transactions/show")) { 
		}
		assertEquals(testURL + "transactions/show", driver.getCurrentUrl());
		
		driver.findElement(By.xpath("//*[contains(text(),'" + "individual history" + "')]")).click();
		
		while (loadingPage) {
			try {
				driver.findElement(By.xpath("//*[contains(text(),'" + "back" + "')]"));
				loadingPage = false;
			} catch (Exception e) {}
		}
		
		assertTrue(driver.findElements(By.xpath("//*[contains(text(),'" + "pet penguin" + "')]")).size() > 0);
		driver.findElement(By.xpath("//*[contains(text(),'" + "back" + "')]")).click();
		while (!driver.getCurrentUrl().equals(testURL + "transactions/show")) {}
	}
	
	/**
	 * Test Announcements functionality.
	 */
	@Test(dependsOnMethods = {"TestUserHouseholdInvites", "TestTransactions"})
	public static void TestAnnouncements() {
		driver.findElement(By.xpath("//*[@href='/announcements/show']")).click();
		while (!driver.getCurrentUrl().equals(testURL + "announcements/show")) {}
		String randomAnnouncement = "This is a test announcement";
		driver.findElement(By.name("text")).sendKeys(randomAnnouncement);
		driver.findElement(By.name("commit")).click();
		assertTrue(driver.findElements(By.xpath("//*[contains(text(),'" + randomAnnouncement + "')]")).size() > 0);
		driver.findElement(By.xpath("//*[@class='col-md-12 announcement-text']")).click();
		//WebElement textArea = driver.findElement(By.xpath("//*[@class='row announcement']"));
		//textArea.findElement(By.xpath("//*[contains(textarea)]")).sendKeys("edit");
		driver.findElement(By.xpath("//*[@class='btn delete-announcement']")).click();
	}
	
	/**
	 * Test Settings functionality.
	 */
	@Test(dependsOnMethods = {"TestUserHouseholdInvites", "TestTransactions", "TestAnnouncements"})
	public static void TestSettings() {
		driver.findElement(By.xpath("//*[@href='/settings/show']")).click();
		while (!driver.getCurrentUrl().equals(testURL + "settings/show")) {}
		String newHouseholdName = "Test Household 2";
		driver.findElement(By.id("household_name")).sendKeys(newHouseholdName);
		driver.findElement(By.name("commit")).click();
		driver.findElement(By.xpath("//*[@href='/home']")).click();
		while (!driver.getCurrentUrl().equals(testURL + "home")) {}
		assertTrue(driver.findElements(By.xpath("//*[contains(text(),'" + newHouseholdName + "')]")).size() > 0);	
	}
	
	@Test(dependsOnMethods = {"TestUserHouseholdInvites", "TestTransactions", "TestAnnouncements", "TestSettings"})
	public static void TestCalendar() {
		driver.findElement(By.xpath("//*[@href='/events/show']")).click();
		while (!driver.getCurrentUrl().equals(testURL + "events/show")) {}
		
		driver.findElement(By.xpath("//*[@class='btn btn-primary']")).click();
		while (!driver.getCurrentUrl().equals(testURL + "events/new")){}
		driver.findElement(By.name("name")).sendKeys("Test Event");
		
		String text = driver.findElement(By.id("datetimepicker_start")).getText();
		System.out.println(text);
		driver.findElement(By.id("datetimepicker_start")).clear();
		driver.findElement(By.id("datetimepicker_start")).sendKeys("1/06/2015 11:00 AM");
		
		driver.findElement(By.id("datetimepicker_end")).clear();
		driver.findElement(By.id("datetimepicker_end")).sendKeys("1/06/2015 12:00 PM");
		
		driver.findElement(By.name("name")).click();
		driver.findElement(By.name("commit")).click();
		while (!driver.getCurrentUrl().equals(testURL + "events/show")) {}
		assertTrue(driver.findElements(By.xpath("//*[contains(text(),'" + "Event has been created" + "')]")).size() > 0);
	}
	
	@AfterMethod
	public void tearDown() {
		System.out.println("@AfterMethod: The annotated method will be run after each test method.");
	}

}