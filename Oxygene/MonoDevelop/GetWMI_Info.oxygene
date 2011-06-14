<?xml version="1.0" encoding="utf-8"?>
<Project DefaultTargets="Build" ToolsVersion="3.5" xmlns="http://schemas.microsoft.com/developer/msbuild/2003">
  <PropertyGroup>
    <Configuration Condition=" '$(Configuration)' == '' ">Debug</Configuration>
    <Platform Condition=" '$(Platform)' == '' ">x86</Platform>
    <ProductVersion>3.5</ProductVersion>
    <SchemaVersion>2.0</SchemaVersion>
    <ProjectGuid>{F3043BF1-BB6F-42F2-82ED-54D0969AABB4}</ProjectGuid>
    <OutputType>Exe</OutputType>
    <RootNamespace>monowmi</RootNamespace>
    <AllowLegacyOutParams>false</AllowLegacyOutParams>
    <RunPostBuildEvent>OnBuildSuccess</RunPostBuildEvent>
    <AllowLegacyCreate>false</AllowLegacyCreate>
    <AllowGlobals>false</AllowGlobals>
    <AssemblyName>monowmi</AssemblyName>
    <TargetFrameworkVersion>v3.5</TargetFrameworkVersion>
    <DefaultNamespace>monowmi</DefaultNamespace>
  </PropertyGroup>
  <PropertyGroup Condition=" '$(Configuration)|$(Platform)' == 'Debug|x86' ">
    <DebugSymbols>true</DebugSymbols>
    <DebugType>full</DebugType>
    <OutputPath>bin\Debug</OutputPath>
    <DefineConstants>DEBUG;TRACE;</DefineConstants>
    <ErrorReport>prompt</ErrorReport>
    <RuntimeVersion>v25</RuntimeVersion>
    <CpuType>anycpu</CpuType>
    <WebDebugTarget>Cassini</WebDebugTarget>
    <XmlDocWarning>WarningOnPublicMembers</XmlDocWarning>
    <StartMode>Project</StartMode>
    <GeneratePDB>true</GeneratePDB>
    <EnableAssert>true</EnableAssert>
    <GenerateMDB>true</GenerateMDB>
  </PropertyGroup>
  <PropertyGroup Condition=" '$(Configuration)|$(Platform)' == 'Release|x86' ">
    <DebugType>none</DebugType>
    <OutputPath>bin\Release</OutputPath>
    <ErrorReport>prompt</ErrorReport>
    <RuntimeVersion>v25</RuntimeVersion>
    <XmlDocWarning>WarningOnPublicMembers</XmlDocWarning>
    <WebDebugTarget>Cassini</WebDebugTarget>
    <CpuType>anycpu</CpuType>
    <EnableAssert>true</EnableAssert>
    <StartMode>Project</StartMode>
  </PropertyGroup>
  <ItemGroup>
    <Reference Include="mscorlib" />
    <Reference Include="System" />
    <Reference Include="System.Data" />
    <Reference Include="System.Xml" />
    <Reference Include="System.Core">
    </Reference>
    <Reference Include="System.Xml.Linq">
    </Reference>
    <Reference Include="System.Data.DataSetExtensions">
    </Reference>
    <Reference Include="System.Management" />
  </ItemGroup>
  <ItemGroup>
    <Compile Include="Program.pas" />
    <Compile Include="Properties\AssemblyInfo.pas" />
    <Compile Include="Properties\Resources.Designer.pas" />
    <Compile Include="Properties\Settings.Designer.pas" />
  </ItemGroup>
  <ItemGroup>
    <None Include="Properties\Resources.resx" />
    <None Include="Properties\Settings.settings" />
  </ItemGroup>
  <Import Project="$(MSBuildExtensionsPath)\RemObjects Software\Oxygene\RemObjects.Oxygene.targets" />
</Project>